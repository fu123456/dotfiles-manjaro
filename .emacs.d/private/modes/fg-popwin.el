(require 'popwin)
(popwin-mode 1)
                                        ; (global-set-key (kbd "C-z") 'popwin:keymap)
                                        ; (global-set-key (kbd "<SPC>ee") 'popwin:close-popup-window)
                                        ; (define-key key-translation-map (kbd "ESC") (kbd "<SPC>ee"))
(global-set-key (kbd "C-g") popwin:keymap)
(global-set-key (kbd "C-g C-g") 'popwin:close-popup-window)

;; M-x anythinqg
(setq anything-samewindow nil)
(push '("*anything*" :height 20) popwin:special-display-config)

;; M-x dired-jump-other-window
(push '(dired-mode :position top) popwin:special-display-config)

;; M-x compile
(push '(compilation-mode :noselect t) popwin:special-display-config)

;; slime
(push "*slime-apropos*" popwin:special-display-config)
(push "*slime-macroexpansion*" popwin:special-display-config)
(push "*slime-description*" popwin:special-display-config)
(push '("*slime-compilation*" :noselect t) popwin:special-display-config)
(push "*slime-xref*" popwin:special-display-config)
(push '(sldb-mode :stick t) popwin:special-display-config)
(push 'slime-repl-mode popwin:special-display-config)
(push 'slime-connection-list-mode popwin:special-display-config)

;; vc
(push "*vc-diff*" popwin:special-display-config)
(push "*vc-change-log*" popwin:special-display-config)

;; undo-tree
(push '(" *undo-tree*" :width 0.3 :position right) popwin:special-display-config)

(push "*gnuplot*" popwin:special-display-config)
(push "*quickrun*" popwin:special-display-config)
(push "*Shell Command Output*" popwin:special-display-config)
(push "*Message*" popwin:special-display-config)
(push "*Backtrace*" popwin:special-display-config)
(push "*Messages*" popwin:special-display-config)
(push "*Warnings*" popwin:special-display-config)
(push "*MATLAB*" popwin:special-display-config)
(push "*latex-math-preview-tex-processing-error*" popwin:special-display-config)
(push "*latex-math-preview-expression*" popwin:special-display-config)
(push "*Org PDF Latex Output*" popwin:special-display-config)
(push "*Org Agenda*" popwin:special-display-config)
(push "*quickrun*" popwin:special-display-config)
(push "*PDF-Occur*" popwin:special-display-config)
