;; deft setting for notes
(setq deft-extensions '("org" "md" "txt"))
(setq deft-directory "/home/fg/MEGA/notes")
(setq deft-recursive t)
(setq deft-auto-save-interval 6.0)
(setq deft-org-mode-title-prefix "#+Title")
(global-set-key (kbd "<f12>") 'deft)
(global-set-key (kbd "C-x C-g") 'deft-find-file)

(provide 'fg-deft)
;; fg-deft.el ends here
