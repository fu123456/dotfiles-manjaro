#!/bin/bash
# Backup my .emacs.d and .spacemacs to my Sumsun dirve

## zip  my emacs config files
echo "zip my emacs config files ... ..."
target_path="/run/media/fg/fugang/Backup/Linux_software"
zip -r ${HOME}/emacs-config-fg.zip ${HOME}/.emacs.d ~/.spacemacs
mv ${HOME}/emacs-config-fg.zip ${target_path}

## using Rsync, sync emacs config files to my Sumsun drive
echo "Rsync, backup my emacs config files"
target_path=/run/media/fg/fugang/Backup/Linux_software
origin_path=/home/fg
echo "Backup .emacs.d directory, please waiting ... ..."
# backup command
# -K: --keep-dirlinks
# --delete: make rsync delete files that have been deleted from the source folder
rsync -avK --delete --progress ${origin_path}/.emacs.d ${target_path}
rsync -avK --delete --progress ${origin_path}/.spacemacs ${target_path}
echo "Backup .emacs.d directory, have finished."
