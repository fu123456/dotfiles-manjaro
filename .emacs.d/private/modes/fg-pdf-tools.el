(package-initialize t)
(package-activate 'pdf-tools)
(pdf-tools-install)
;;grap org-pdfview https://github.com/markus1189/org-pdfview/blob/master/org-pdfview.el
(eval-after-load 'org '(require 'org-pdfview))
(add-to-list 'org-file-apps '("\\.pdf\\'" . org-pdfview-open))
(add-to-list 'org-file-apps '("\\.pdf::\\([[:digit:]]+\\)\\'" . org-pdfview-open))

(eval-after-load 'pdf-view
  '(define-key pdf-view-mode-map (kbd "M-h") 'pdf-annot-add-highlight-markup-annotation))
(eval-after-load 'pdf-view
  '(define-key pdf-view-mode-map (kbd "<tab>") 'pdf-annot-add-highlight-markup-annotation))

;;importing and exporting pdf annotations from/to org files.
;;https://github.com/pinguim06/pdf-tools-org
(add-to-list 'load-path "~/MEGA/dotfiles-manjaro/.emacs.d/private/OtherUsefulElFiles")
(require 'pdf-tools-org)
;;auto save org when pdf file closed
(add-hook 'after-save-hook
          (lambda ()
            (when (eq major-mode 'pdf-view-mode) (pdf-tools-org-export-to-org-mod))))

;; modify the original function (see below) to add page link back to pdf file, Tan
(defun pdf-tools-org-export-to-org-mod ()
  "Export annotations to an Org file."
  (interactive)
   (setq fname buffer-file-name)
  (let ((annots (sort (pdf-annot-getannots) 'pdf-annot-compare-annotations))
        (filename (format "%s.org"
                          (file-name-sans-extension
                           (buffer-name))))
        (buffer (current-buffer)))
    (with-temp-buffer
      ;; org-set-property sometimes never returns if buffer not in org-mode
      (org-mode)
      (insert (concat "#+TITLE: Annotation notes for " (file-name-sans-extension filename)))
      (mapc
       (lambda (annot) ;; traverse all annotations
         (progn
           (org-insert-heading-respect-content)
      ;;retrieve page # for annotation (number-to-string (assoc-default 'page annot))
      ;;  (insert (number-to-string (nth 1 (assoc-default 'edges annot)))) for margin
       (insert (concat (symbol-name (pdf-annot-get-id annot)) "\s[[pdfview:" fname  "::" (number-to-string (assoc-default 'page annot))
     		       "++" (number-to-string (nth 1 (assoc-default 'edges annot)))  "][p." (number-to-string (assoc-default 'page annot))  "]]" ))
     	(insert (concat " :" (symbol-name (pdf-annot-get-type annot)) ":"))
       ;; insert text from marked-up region in an org-mode quote
           (when (pdf-annot-get annot 'markup-edges)
             (insert (concat "\n#+BEGIN_QUOTE\n"
                             (with-current-buffer buffer
                                  (pdf-info-gettext (pdf-annot-get annot 'page)
                                               (pdf-tools-org-edges-to-region
                                                (pdf-annot-get annot 'markup-edges))))
                           "\n#+END_QUOTE")))
         (insert (concat "\n\n" (pdf-annot-get annot 'contents)))
         ;; set org properties for each of the remaining fields
         (mapcar
          '(lambda (field) ;; traverse all fields
             (when (member (car field) pdf-tools-org-exportable-properties)
               (org-set-property (symbol-name (car field))
                                 (format "%s" (cdr field)))))
          annot)))
     (cl-remove-if
      (lambda (annot) (member (pdf-annot-get-type annot) pdf-tools-org-non-exportable-types))
      annots)
     )
    (org-set-tags 1)
(write-file filename pdf-tools-org-export-confirm-overwrite))))

;;auto save org when pdf file closed
(add-hook 'after-save-hook
          (lambda ()
            (when (eq major-mode 'pdf-view-mode)
              (pdf-tools-org-export-to-org-mod))))

(defun pdf-annot-markups-as-org-text (pdfpath &optional title level)
"Acquire highlight annotations as text"

(interactive "fPath to PDF: ")
(let* ((outputstring "") ;; the text to be return
       (title (or title (replace-regexp-in-string "-" " " (file-name-base pdfpath ))))
       (level (or level (1+ (org-current-level)))) ;; I guess if we're not in an org-buffer this will fail
       (levelstring (make-string level ?*))
       (pdf-image-buffer (get-buffer-create "*temp pdf image*"))
       )
  (with-temp-buffer ;; use temp buffer to avoid opening zillions of pdf buffers
    (insert-file-contents pdfpath)
    (pdf-view-mode)
    (pdf-annot-minor-mode t)
    (ignore-errors (pdf-outline-noselect (current-buffer)))

    (setq outputstring (concat levelstring " Annotations from " title "\n\n")) ;; create heading

    (let* ((annots (sort (pdf-annot-getannots nil (list 'square 'highlight)  nil)
                         'pdf-annot-compare-annotations))
           (last-outline-page -1))
      (mapc
       (lambda (annot) ;; traverse all annotations
         (message "%s" annot)
         (let* ((page (assoc-default 'page annot))
                (height (nth 1 (assoc-default 'edges annot)))
                (type (assoc-default 'type annot))
                (id (symbol-name (assoc-default 'id annot)))
                (text (pdf-info-gettext page (assoc-default 'edges annot)))
                (imagefile (concat id ".png"))
                (region (assoc-default 'edges annot))
                ;; use pdfview link directly to page number
                (linktext (concat "[[pdfview:" pdfpath "::" (number-to-string page)
                                  "++" (number-to-string height) "][" title  "]]" ))
                ;; The default export is for highlight annotations
                (annotation-as-org (concat text "\n(" linktext ", " (number-to-string page) ")\n\n"))
                )

           ;; Square annotations are written to images and displayed inline
        (when (eq type 'square)
          (pdf-view-extract-region-image (list region) page (cons 1000 1000) pdf-image-buffer)
          (with-current-buffer pdf-image-buffer
            (write-file imagefile))
          (setq annotation-as-org (concat "[[file:" imagefile "]]" "\n\n(" linktext ", " (number-to-string page) ")\n\n")))

        ;; Insert outline heading if not already inserted
        (let* ((outline-info (ignore-errors
                               (with-current-buffer (pdf-outline-buffer-name)
                                 (pdf-outline-move-to-page page)
                                 (pdf-outline-link-at-pos))))
                (outline-page (when outline-info (number-to-string (assoc-default 'page outline-info)))))
           (when outline-info
             (unless (equal last-outline-page outline-page)
               (setq outputstring (concat outputstring
                                          (make-string (+ level (assoc-default 'depth outline-info)) ?*)
                                          " "
                                          (assoc-default 'title outline-info)
                                          ", "
                                          outline-page
                                          "\n\n"))
               (setq last-outline-page outline-page))))

         (setq outputstring (concat outputstring annotation-as-org)))
       )
     annots))
  )
(insert outputstring)
))

;; key setting
(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install)
  ;; (setq-default pdf-view-display-size 'fit-page)
  (bind-keys :map pdf-view-mode-map
             ("\\" . hydra-pdftools/body)
             ("<s-spc>" .  pdf-view-scroll-down-or-next-page)
             ("g"  . pdf-view-first-page)
             ("G"  . pdf-view-last-page)
             ("l"  . image-forward-hscroll)
             ("h"  . image-backward-hscroll)
             ("j"  . pdf-view-next-page)
             ("k"  . pdf-view-previous-page)
             ("e"  . pdf-view-goto-page)
             ("U"  . pdf-view-revert-buffer)
             ("al" . pdf-annot-list-annotations)
             ("ad" . pdf-annot-delete)
             ("aa" . pdf-annot-attachment-dired)
             ("am" . pdf-annot-add-markup-annotation)
             ("at" . pdf-annot-add-text-annotation)
             ("y"  . pdf-view-kill-ring-save)
             ("i"  . pdf-misc-display-metadata)
             ("s"  . pdf-occur)
             ("b"  . pdf-view-set-slice-from-bounding-box)
             ("r"  . pdf-view-reset-slice)
             ("w"  . save-buffer)
             )
  (use-package org-pdfview
    :ensure t)
  )

;; set pdf file on the right
;; http://mbork.pl/2016-06-13_Displaying_pdfs_on_the_right
(defvar pdf-minimal-width 72
  "Minimal width of a window displaying a pdf.
If an integer, number of columns.  If a float, fraction of the
original window.")

(defvar pdf-split-width-threshold 120
  "Minimum width a window should have to split it horizontally
for displaying a pdf in the right.")

(defun pdf-split-window-sensibly (&optional window)
  "A version of `split-window-sensibly' for pdfs.
It prefers splitting horizontally, and takes `pdf-minimal-width'
into account."
  (let ((window (or window (selected-window)))
	(width (- (if (integerp pdf-minimal-width)
		      pdf-minimal-width
		    (round (* pdf-minimal-width (window-width window)))))))
    (or (and (window-splittable-p window t)
	     ;; Split window horizontally.
	     (with-selected-window window
	       (split-window-right width)))
	(and (window-splittable-p window)
	     ;; Split window vertically.
	     (with-selected-window window
	       (split-window-below)))
	(and (eq window (frame-root-window (window-frame window)))
	     (not (window-minibuffer-p window))
	     ;; If WINDOW is the only window on its frame and is not the
	     ;; minibuffer window, try to split it vertically disregarding
	     ;; the value of `split-height-threshold'.
	     (let ((split-height-threshold 0))
	       (when (window-splittable-p window)
		 (with-selected-window window
		   (split-window-below))))))))

(defun display-buffer-pop-up-window-pdf-split-horizontally (buffer alist)
  "Call `display-buffer-pop-up-window', using `pdf-split-window-sensibly'
when needed."
  (let ((split-height-threshold nil)
	(split-width-threshold pdf-split-width-threshold)
	(split-window-preferred-function #'pdf-split-window-sensibly))
    (display-buffer-pop-up-window buffer alist)))

(add-to-list 'display-buffer-alist '("\\.pdf\\(<[^>]+>\\)?$" . (display-buffer-pop-up-window-pdf-split-horizontally)))
