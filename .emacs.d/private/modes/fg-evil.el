;;{{{ evil-collection
;; see @ https://github.com/emacs-evil/evil-collection
(evil-collection-init)
;; enable Evil in the minibuffer
(use-package evil-collection
  :custom (evil-collection-setup-minibuffer t)
  :init (evil-collection-init))
;;}}}
