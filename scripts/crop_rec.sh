#!/bin/bash
# img_dir='/home/fg/MEGA/sync/shadow-detection/results/goodresults/my/refine_shading';
# output_dir='/home/fg/MEGA/sync/shadow-detection/results/goodresults/my/output';

for img in $1/kitchen*.png; do
    filename=`basename ${img}`
    filename="${filename%.*}"
    echo ${filename}.png
    echo crop interested regions
    convert ${img} -crop $2  \
            $1/${filename}-crop.png
done
