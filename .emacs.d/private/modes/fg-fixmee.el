(add-to-list 'load-path "/home/fg/MEGA/dotfiles-manjaro/.emacs.d/private/myPackages/fixmee")
;; (require 'button-lock)
;; (require 'fixmee)

;; (global-fixmee-mode 1)

;; right-click on the word "fixme" in a comment

;; for next-error support:
;;
;; M-x fixmee-view-listing RET
(use-package fixmee
  :init (require 'button-lock)
  :config (global-fixmee-mode 1))
