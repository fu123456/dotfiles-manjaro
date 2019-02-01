#!/bin/bash
# Backup my home config file to my Sumsun drive
origin_path=/home/fg
target_path=/run/media/fg/fugang/Backup/Home
rsync -avK --delete --progress --exclude '.Pycharm*' ${origin_path}/.* ${target_path}
rsync -avK --delete --progress --exclude '.Pycharm*' ${origin_path}/MEGA ${target_path}
