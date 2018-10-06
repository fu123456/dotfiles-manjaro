(require 'workgroups2)
(workgroups-mode 1)
;; Change prefix key (before activating WG)
(setq wg-prefix-key (kbd "C-c z"))

;; Change workgroups session file
(setq wg-session-file "~/.emacs.d/.emacs_workgroups")

;; Set your own keyboard shortcuts to reload/save/switch WGs:
;; "s" == "Super" or "Win"-key, "S" == Shift, "C" == Control
(global-set-key (kbd "<pause>")     'wg-reload-session)
(global-set-key (kbd "C-S-<pause>") 'wg-save-session)
(global-set-key (kbd "s-z")         'wg-switch-to-workgroup)
(global-set-key (kbd "s-/")         'wg-switch-to-previous-workgroup)
