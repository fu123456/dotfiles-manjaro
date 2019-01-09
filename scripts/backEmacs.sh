#!/bin/bash
# {{{back my emacs config files
target_path="/run/media/fg/fugang/Backup/Linux_software"
zip -r ${HOME}/emacs-config-fg.zip ${HOME}/.emacs.d/* ~/.spacemacs
mv ${HOME}/emacs-config-fg.zip ${target_path}
# }}}
