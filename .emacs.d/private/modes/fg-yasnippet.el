;;; yasnippet
;;; should be loaded before auto complete so that they can work together
(require 'yasnippet)
;; helm-c-yasnippet
(add-to-list 'load-path "~/.emacs.d/private/myPackages/helm-c-yasnippet")
(yas-global-mode +1)
(define-key yas-minor-mode-map (kbd "TAB") yas-maybe-expand)
(define-key yas-minor-mode-map (kbd "<tab>") #'yas-expand)

;; ;;; auto complete mod
;; ;;; should be loaded after yasnippet so that they can work together
;; (require 'auto-complete-config)
;; (auto-complete-mode 1)
;; (add-to-list 'ac-dictionary-directories "/home/fg/.emacs.d/elpa/develop/auto-complete-20170125.245/dict")
;; ;;; set the trigger key so that it can work together with yasnippet on tab key,
;; ;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;; ;;; activate, otherwise, auto-complete will
;; (ac-set-trigger-key "TAB")
;; (ac-set-trigger-key "<tab>")
;; (define-key ac-completing-map "\t" 'ac-complete)
;; (define-key ac-completing-map "\r" nil)
;; (setq ac-use-menu-map t)
;; ;; Default settings
;; (define-key ac-menu-map "\C-n" 'ac-next)
;; (define-key ac-menu-map "\C-p" 'ac-previous)
