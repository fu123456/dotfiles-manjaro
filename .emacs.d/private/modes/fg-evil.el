;;{{{ evil-collection
;; see @ https://github.com/emacs-evil/evil-collection
(evil-collection-init)
;; enable Evil in the minibuffer
(use-package evil-collection
  :custom (evil-collection-setup-minibuffer t)
  :init (evil-collection-init))
;;}}}

;;
(evil-escape-mode 1)
(setq-default evil-escape-key-sequence "jk")
(setq-default evil-escape-delay 0.2)
(global-set-key (kbd "C-c C-g") 'evil-escape)
