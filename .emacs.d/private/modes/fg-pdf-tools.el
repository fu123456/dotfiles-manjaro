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
;; (add-to-list 'load-path "/home/tan/config/emacs/extend/pdf-tools-org/")
(require 'pdf-tools-org)
;;auto save org when pdf file closed
(add-hook 'after-save-hook
          (lambda ()
            (when (eq major-mode 'pdf-view-mode) (pdf-tools-org-export-to-org-mod))))
