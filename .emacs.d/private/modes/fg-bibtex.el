;; (add-to-list 'load-path "/home/fg/MEGA/dotfiles-manjaro/.emacs.d/private/myPackages/helm-bibtex")
;; ;; {{{ ivy-bibtex
;; (autoload 'ivy-bibtex "ivy-bibtex" "" t)
;; ;; ivy-bibtex requires ivy's `ivy--regex-ignore-order` regex builder, which
;; ;; ignores the order of regexp tokens when searching for matching candidates.
;; ;; Add something like this to your init file:
;; (setq ivy-re-builders-alist
;;       '((ivy-bibtex . ivy--regex-ignore-order)
;;         (t . ivy--regex-plus)))
;; ;; }}}
(autoload 'helm-bibtex "helm-bibtex" "" t)

;; {{{ open PDF using Zathura
(with-eval-after-load 'helm-bibtex
  (defun bibtex-completion-open-pdf-external (keys &optional fallback-action)
    (let ((bibtex-completion-pdf-open-function
           (lambda (fpath) (start-process "zathura" "helm-bibtex-zathura" "/usr/bin/zathura" fpath))))
      (bibtex-completion-open-pdf (list keys) fallback-action)))
  (helm-add-action-to-source
   "Zathura (PDF)" 'bibtex-completion-open-pdf-external
   helm-source-bibtex 0)
  )
  ;; }}}

  (setq bibtex-completion-bibliography
        '("~/MEGA/bibtex-pdfs/bib/references.bib"))
(setq bibtex-completion-library-path '("/home/fg/MEGA/bibtex-pdfs/"))
;; (setq bibtex-completion-notes-path "~/MEGA/bibtex-pdfs/notesbib.org")
(setq bibtex-completion-notes-path "~/MEGA/bibtex-pdfs/notes")
(setq bibtex-completion-display-formats
      '((article       . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} ${journal:40}")
        (inbook        . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} Chapter ${chapter:32}")
        (incollection  . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
        (inproceedings . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*} ${booktitle:40}")
        (t             . "${=has-pdf=:1}${=has-note=:1} ${=type=:3} ${year:4} ${author:36} ${title:*}")))

;; Symbols used for indicating the availability of notes and PDF files
(setq bibtex-completion-pdf-symbol "⌘")
(setq bibtex-completion-notes-symbol "✎")

(defun bibtex-completion-open-annotated-pdf (keys)
  (--if-let
	    (-flatten
	     (-map (lambda (key)
		           (bibtex-completion-find-pdf (s-concat key "-annotated")))
	           keys))
	    (-each it bibtex-completion-pdf-open-function)
    (message "No PDF(s) found.")))

;; Browser used for opening URLs and DOIs
(setq bibtex-completion-browser-function 'browser-url-chromium)

;; Format of citations
(setq bibtex-completion-format-citation-functions
      '((org-mode      . bibtex-completion-format-citation-org-link-to-PDF)
        (latex-mode    . bibtex-completion-format-citation-cite)
        (markdown-mode . bibtex-completion-format-citation-pandoc-citeproc)
        (default       . bibtex-completion-format-citation-default)))

(setq bibtex-completion-additional-search-fields '(tags))

;; Predefined searches
(defun helm-bibtex-my-publications (&optional arg)
  "Search BibTeX entries authored by “Jane Doe”.

With a prefix ARG, the cache is invalidated and the bibliography reread."
  (interactive "P")
  (when arg
    (bibtex-completion-clear-cache))
  (helm :sources (list helm-source-bibtex helm-source-fallback-options)
        :full-frame helm-bibtex-full-frame
        :buffer "*helm bibtex*"
        :input "Jane Doe"
        :candidate-number-limit 500))

(advice-add 'bibtex-completion-candidates
            :filter-return 'reverse)

(setq bibtex-completion-find-additional-pdfs t)

;; my keybinding setting for helm-bibtex
(define-key evil-normal-state-map (kbd "<SPC>hb") 'helm-bibtex)
