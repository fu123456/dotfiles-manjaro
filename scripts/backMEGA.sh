#!/bin/bash

# do not add '' or "" for directory, if add, it does not work
target_path=/run/media/fg/fugang/Backup/MEGA
origin_path=/home/fg/MEGA
echo "Backup MEGA directory, please waiting ... ..."
# backup command
# -K: --keep-dirlinks
# --delete: make rsync delete files that have been deleted from the source folder
rsync -avRK --delete --progress ${origin_path} ${target_path}
echo "Backup MEGA directory, have finished."
