(autoload 'helm-bibtex "helm-bibtex" "" t)
(setq bibtex-completion-bibliography
      '("~/MEGA/bibtex-pdfs/bib/references.org"))
(setq bibtex-completion-library-path '("~/MEGA/bibtex-pdfs/"))
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
