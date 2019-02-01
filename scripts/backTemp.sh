#!/bin/bash

# see https://stackoverflow.com/questions/4585929/how-to-use-cp-command-to-exclude-a-specific-directory
# back my Thinkpad PHD directory to my Sumsun drive
# rsync -av --progress /home/fg/PHD /run/media/fg/fugang/Backup/Research --exclude-from '/home/fg/PHD/Experiments/Datas/intrinsic_decom_RGB_results'
# rsync -av --progress /home/fg/MEGA /run/media/fg/fugang/Backup/Research
# rsync -av --progress /home/fg/PHD /run/media/fg/fugang/Backup/Research

# {{{back my emacs config files
# zip -r ~/emacs-config-fg.zip ~/.emacs.d/*
# mv ~/emacs-config-fg.zip /run/media/fg/fugang/Backup/Linux_software
# }}}

rsync -av --progress --exclude='*.zip' /home/fg/Downloads  /run/media/fg/AA2E-AB35/Backup/2019_1_1
