#!/bin/bash
rsync -avR --progress --delete /home/fg/MEGA /run/media/fg/Seagate\ Backup\ Plus\ Drive/PHD_all && \
    rsync -avR --progress --delete /home/fg/PHD /run/media/fg/Seagate\ Backup\ Plus\ Drive/PHD_all && \
    rsync -avR --progress --delete /home/fg/.emacs.d /run/media/fg/Seagate\ Backup\ Plus\ Drive/PHD_all && \
    rsync -avR --progress --delete /home/fg/.spacemacs /run/media/fg/Seagate\ Backup\ Plus\ Drive/PHD_all
