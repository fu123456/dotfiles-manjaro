#!/bin/bash

# see https://stackoverflow.com/questions/4585929/how-to-use-cp-command-to-exclude-a-specific-directory
rsync -av --progress /home/fg/PHD /run/media/fg/fugang/Backup/Research --exclude '/home/fg/PHD/Experiments/Datas/intrinsic_decom_RGB_results'
