;; Code folding config

;;{{{ folding-mode
;; see @ https://www.emacswiki.org/emacs/FoldingMode
(add-to-list 'load-path "~/.emacs.d/private/fold")
(load "folding" 'nomessage 'noerror)
(folding-mode-add-find-file-hook)
(folding-add-to-marks-list 'latex-mode "%{{{" "%}}}" nil t)
(folding-add-to-marks-list 'Latex-mode "%{{{" "%}}}" nil t)
;; keybinding
(define-key evil-normal-state-map (kbd "TAB") 'folding-toggle-show-hide)
;;}}}
