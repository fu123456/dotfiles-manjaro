(add-to-list 'load-path "/home/fg/.emacs.d/private/myPackages/super-save")

;; {{{
;; see @https://github.com/bbatsov/super-save
(use-package super-save
  :ensure t
  :config
  (super-save-mode +1))
(setq super-save-auto-save-when-idle t)
;; close default auto save mode
(setq auto-save-default nil)
;; add integration with ace-window
(add-to-list 'super-save-triggers 'ace-window)
;; save on find-file
(add-to-list 'super-save-hook-triggers 'find-file-hook)
(setq super-save-remote-files nil)
;; }}}
