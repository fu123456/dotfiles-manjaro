;; load quickrun.el file
(add-to-list 'load-path "~/.emacs.d/private/myPackages/emacs-quickrun")
(require 'quickrun)
(global-unset-key (kbd "<f6>"))
(global-set-key (kbd "<f6>") 'quickrun)
(global-set-key (kbd "M-<f6>") 'quickrun-compile-only)
(global-set-key (kbd "C-<f6>") 'quickrun-with-arg)

;; compile large latex file, e.g. my paper
;; shell script file is in dir:"/home/fg/MEGA/dotfiles-manjaro/scripts/compile-latex"
(quickrun-add-command "fg/pdflatex-bibtex-pdflatex"
  '((:command . "bash /home/fg/MEGA/dotfiles-manjaro/scripts/compile-latex")
    (:exec    . "%c compile %s")
    :mode 'latex-mode))
(quickrun-add-command "fg/pdflatex-bibtex-xelatex"
  '((:command . "bash /home/fg/MEGA/dotfiles-manjaro/scripts/compile-chinese-latex")
    (:exec    . "%c compile %s")
    :mode 'latex-mode))
(quickrun-add-command "fg/pdflatex"
  '((:command . "pdflatex")
    (:exec    . "%c %s")
    :mode 'latex-mode))
(quickrun-add-command "fg/xelatex"
  '((:command . "xelatex")
    (:exec    . "%c %s")
    :mode 'latex-mode))

(setq quickrun-timeout-seconds nil)

(provide 'fg-quickrun)

;;; fg-quickrun.el ends here
