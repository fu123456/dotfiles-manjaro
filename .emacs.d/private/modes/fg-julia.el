(require 'julia-shell)
;; (require 'julia-shell-mode))
(define-key julia-mode-map (kbd "C-c C-c") 'julia-shell-run-region-or-line)
(define-key julia-mode-map (kbd "C-c C-s") 'julia-shell-save-and-go)

(provide 'fg-julia)
