(add-to-list 'load-path "/home/fg/MEGA/dotfiles-manjaro/.emacs.d/private/myPackages/browse-kill-ring")
(require 'browse-kill-ring)
(global-set-key [(control c)(k)] 'browse-kill-ring)
(browse-kill-ring-default-keybindings)
