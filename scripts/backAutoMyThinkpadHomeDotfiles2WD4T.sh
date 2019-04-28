#!/bin/bash
# backup my all dotfiles in home directory to my WD 4TB
rsync -avR --delete --progress /home/fg/.??* /run/media/fg/7CA91F8557736F51/PHD_all
