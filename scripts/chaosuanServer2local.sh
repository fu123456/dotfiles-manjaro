#!/bin/bash
mkdir -p /home/fg/Temp
# copy, A->B
echo ${B}
rsync -vazu -progress -delete fugang@202.114.96.180:/home/fugang/project/img.sh /home/fg/Temp
