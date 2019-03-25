;; (package-initialize t)
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

;;{{{ auto revert buffer
;; see @ https://github.com/politza/pdf-tools/issues/25
;; (setq auto-revert-interval 0.5)
;; (auto-revert-set-timer)
;; (setq revert-without-query '(".*"))
;; (add-hook 'pdf-view-mode-hook (lambda ()
;; (auto-revert-mode 1)
;; ))
;;}}}

;;importing and exporting pdf annotations from/to org files.
;;https://github.com/pinguim06/pdf-tools-org
(add-to-list 'load-path "~/.emacs.d/private/OtherUsefulElFiles")
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
;; (add-hook 'after-save-hook
;;           (lambda ()
;;             (when (eq major-mode 'pdf-view-mode)
;;               (pdf-tools-org-export-to-org-mod))))

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

;; Avoid hanging Emacs by closing some minor mode
(defun fg/pdf-view-mode-hook ()
  (company-mode -1)
  (auto-complete-mode -1)
  (linum-mode -1)
  (pyim-isearch-mode -1)
  (yas-minor-mode -1)
  (pangu-spacing-mode -1)
  (aggressive-indent-mode -1)
  (line-number-mode -1)
  (font-lock-mode -1)
  (column-number-mode -1)
  (cua-mode -1)
  ;; (eyebrose-mode -1)
  (auto-revert-mode -1)
  (symbol-overlay-mode -1)
  (folding-mode -1)
  )

;; (add-hook 'pdf-view-mode-hook (lambda ()
;;                                 (vlf-mode 1)
;;                                 ))

;; Close evil-mode in pdf-tools
;; to see @ https://github.com/politza/pdf-tools/issues/201
(evil-set-initial-state 'pdf-view-mode 'emacs)
(add-hook 'pdf-view-mode-hook
          (lambda ()
            (set (make-local-variable 'evil-emacs-state-cursor) (list nil))))

(add-hook 'pdf-view-mode-hook 'fg/pdf-view-mode-hook)

;; (add-to-list 'display-buffer-alist '("\\.pdf\\(<[^>]+>\\)?$" . (display-buffer-pop-up-window-pdf-split-horizontally)))

;; pdf-tool setting using hydra
(defhydra hydra-pdftools (:color blue :hint nil)
  "
                                                                      ╭───────────┐
       Move  History   Scale/Fit     Annotations  Search/Link    Do   │ PDF Tools │
   ╭──────────────────────────────────────────────────────────────────┴───────────╯
         ^^_gg_^^      _B_    ^↧^    _+_    ^ ^     [_al_] list    [_s_] search    [_u_] revert buffer
         ^^^↑^^^      ^↑^    _H_    ^↑^  ↦ _W_ ↤   [_am_] markup  [_o_] outline   [_i_] info
         ^^_p_^^      ^ ^    ^↥^    _0_    ^ ^     [_at_] text    [_F_] link      [_d_] dark mode
         ^^^↑^^^      ^↓^  ╭─^─^─┐  ^↓^  ╭─^ ^─┐   [_ad_] delete  [_f_] search link
    _h_ ←pag_e_→ _l_  _N_  │ _P_ │  _-_    _b_     [_aa_] dired
         ^^^↓^^^      ^ ^  ╰─^─^─╯  ^ ^  ╰─^ ^─╯   [_y_]  yank
         ^^_n_^^      ^ ^  _r_eset slice box
         ^^^↓^^^
         ^^_G_^^
   --------------------------------------------------------------------------------
        "
  ("\\" hydra-master/body "back")
  ("<ESC>" nil "quit")
  ("al" pdf-annot-list-annotations)
  ("ad" pdf-annot-delete)
  ("aa" pdf-annot-attachment-dired)
  ("am" pdf-annot-add-markup-annotation)
  ("at" pdf-annot-add-text-annotation)
  ("y"  pdf-view-kill-ring-save)
  ("+" pdf-view-enlarge :color red)
  ("-" pdf-view-shrink :co(setq helm-bibtex-pdf-open-function
                                (lambda (fpath)
                                  (call-process "pdf-tools" nil 0 nil fpath)))lor red)
  ("0" pdf-view-scale-reset)
  ("H" pdf-view-fit-height-to-window)
  ("W" pdf-view-fit-width-to-window)
  ("P" pdf-view-fit-page-to-window)
  ("n" pdf-view-next-page-command :color red)
  ("p" pdf-view-previous-page-command :color red)
  ("d" pdf-view-dark-minor-mode)
  ("b" pdf-view-set-slice-from-bounding-box)
  ("r" pdf-view-reset-slice)
  ("gg" pdf-view-first-page)
  ("G" pdf-view-last-page)
  ("e" pdf-view-goto-page)
  ("o" pdf-outline)
  ("s" pdf-occur)
  ("i" pdf-misc-display-metadata)
  ("u" pdf-view-revert-buffer)
  ("F" pdf-links-action-perfom)
  ("f" pdf-links-isearch-link)
  ("B" pdf-history-backward :color red)
  ("N" pdf-history-forward :color red)
  ("l" image-forward-hscroll :color red)
  ("h" image-backward-hscroll :color red))
;; (global-set-key (kbd "<f5>") 'hydra-pdftools/body)
(define-key pdf-view-mode-map (kbd "<f5>") 'hydra-pdftools/body)

;;{{{ remove some keybinding and define new keybinding in pdf-tools
(define-key pdf-view-mode-map (kbd "SPC") nil)
(define-key pdf-view-mode-map (kbd "SPC hb") 'helm-bibtex)
(define-key pdf-view-mode-map (kbd "SPC w") 'hydra-window/body)
(define-key pdf-view-mode-map (kbd "SPC oy") 'xah-copy-file-path)
(define-key pdf-view-mode-map (kbd "SPC ii") 'ibuffer)
(define-key pdf-view-mode-map (kbd "SPC ff") 'find-file)
(define-key pdf-view-mode-map (kbd "SPC bb") 'switch-to-buffer)
(define-key pdf-view-mode-map (kbd "SPC bp") 'previous-buffer)
(define-key pdf-view-mode-map (kbd "SPC bn") 'next-buffer)
;; window movement like vim style
(define-key pdf-view-mode-map (kbd "C-w j") 'evil-window-down)
(define-key pdf-view-mode-map (kbd "C-w k") 'evil-window-up)
(define-key pdf-view-mode-map (kbd "C-w h") 'evil-window-left)
(define-key pdf-view-mode-map (kbd "C-w l") 'evil-window-right)
;; M-x
(define-key pdf-view-mode-map (kbd "SPC SPC") 'counsel-M-x)
;; buffer
(define-key pdf-view-mode-map (kbd "SPC b p") 'previous-buffer)
(define-key pdf-view-mode-map (kbd "SPC b n") 'next-buffer)
(define-key pdf-view-mode-map (kbd "SPC TAB") 'spacemacs/alternate-buffer)
;; quickly open my files
(define-key pdf-view-mode-map (kbd "SPC a") 'hydra-fgfiles/body)
;;;}}}
(define-key pdf-view-mode-map (kbd "SPC [") 'hydra-tab/body)
(define-key pdf-view-mode-map (kbd "SPC ]") 'hydra-workgroups/body)

;; save some useful buffers quickly
(defun fg/save-some-buffers ()
  "Save my some files: latex file, org file, markdown file, PDf file."
  (interactive)
  (save-some-buffers 'no-confirm (lambda ()
                                   (cond
                                    ((and buffer-file-name (equal buffer-file-name abbrev-file-name)))
                                    ((and buffer-file-name (eq major-mode 'latex-mode)))
                                    ((and buffer-file-name (eq major-mode 'markdown-mode)))
				                            ((and buffer-file-name (eq major-mode 'pdf-view-mode)))
                                    ((and buffer-file-name (derived-mode-p 'org-mode)))))))
(define-key pdf-view-mode-map (kbd "<SPC>fw") 'fg/save-some-buffers)

;; 已经使用 evil-collection-pdf 来代替了
;; ;; {{{ pdf-occur
;; (evil-set-initial-state 'pdf-occur-buffer-mode 'emacs)
;; (defvar pdf-occur-buffer-mode-map
;;   (let ((kmap (make-sparse-keymap)))
;;     (set-keymap-parent kmap tablist-mode-map)
;;     (define-key kmap (kbd "RET") 'pdf-occur-goto-occurrence)
;;     (define-key kmap (kbd "C-o") 'pdf-occur-view-occurrence)
;;     (define-key kmap (kbd "SPC") 'pdf-occur-view-occurrence)
;;     (define-key kmap (kbd "C-c C-f") 'next-error-follow-minor-mode)
;;     (define-key kmap (kbd "g") 'pdf-occur-revert-buffer-with-args)
;;     (define-key kmap (kbd "K") 'pdf-occur-abort-search)
;;     (define-key kmap (kbd "D") 'pdf-occur-tablist-do-delete)
;;     (define-key kmap (kbd "x") 'pdf-occur-tablist-do-flagged-delete)
;;     (define-key kmap (kbd "A") 'pdf-occur-tablist-gather-documents)
;;     kmap)
;;   "The keymap used for `pdf-occur-buffer-mode'.")
;; (define-key pdf-occur-buffer-mode-map (kbd "j") 'next-line)
;; (define-key pdf-occur-buffer-mode-map (kbd "k") 'previous-line)
;; (define-key pdf-occur-buffer-mode-map (kbd "h") 'left-char)
;; (define-key pdf-occur-buffer-mode-map (kbd "l") 'right-char)
;; ;; }}}

;; pdf-view-mode for goldendict
(require 'goldendict)
(evil-leader/set-key (kbd "og") 'goldendict-dwim)
