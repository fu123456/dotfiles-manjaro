(require 'yasnippet)

(add-hook 'latex-mode-hook
          '(lambda () (set (make-local-variable 'yas-indent-line) nil)))
(add-hook 'Latex-mode-hook
          '(lambda () (set (make-local-variable 'yas-indent-line) nil)))
