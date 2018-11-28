#!/bin/bash
rm -rf /home/fg/back
rsync \
    --exclude-from="/home/fg/MEGA/bibtex-pdfs" \
    -avr \
    /home/fg/MEGA \
    /home/fg/back
