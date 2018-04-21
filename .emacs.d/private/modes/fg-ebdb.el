(require 'ebdb)
(require 'ebdb-gnus)
(require 'ebdb-complete)
(require 'pyim)

(setq bbdb-file "~/.emacs.d/ebdb.pgp")

(ebdb-complete-enable)

(defun eh-ebdb-search-chinese (string)
  (if (functionp 'pyim-isearch-build-search-regexp)
      (pyim-isearch-build-search-regexp string)
    string))

(setq ebdb-search-transform-functions
      '(eh-ebdb-search-chinese))
