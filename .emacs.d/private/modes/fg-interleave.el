(add-to-list 'load-path "/home/fg/MEGA/dotfiles-manjaro/.emacs.d/private/myPackages/interleave")
(require 'interleave)
(defun my-interleave-hook ()
  (with-current-buffer interleave-org-buffer
    ;; Do something meaningful here
    (message "Hi there. I'm in the org buffer!")))
(add-hook 'interleave-mode-hook #'my-interleave-hook)
(setq interleave-org-notes-dir-list '("/home/fg/MEGA/bibtex-pdfs/notes" "."))
