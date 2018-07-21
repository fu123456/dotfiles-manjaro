;; see @ https://github.com/rranelli/auto-package-update.el
(require 'auto-package-update)
(auto-package-update-maybe)
(setq auto-package-update-interval 7)
(setq auto-package-update-prompt-before-update t)
(setq auto-package-update-delete-old-versions t)
(add-hook 'auto-package-update-before-hook
          (lambda () (message "I will update packages now")))
