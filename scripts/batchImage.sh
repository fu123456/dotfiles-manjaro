#!/bin/bash
# input your data dir
dataDir='/home/fg/temp/helm-bibtex'
# obtain dir name
cd ${dataDir}
cd ..
outputDir=`pwd`
dataDirName=`echo ${dataDir} | awk -F '/' '{print $NF}'`
batchDir=${outputDir}/${dataDirName}_FuGangBatchResult
echo ${batchDir}
rsync -av --exclude=".*" ${dataDir}/* ${batchDir}
# temp files to cope
image=`find ${batchDir} -name '*' -exec file {} \; | grep -o -P '^.+: \w+ image' | awk -F ":" '{print $1}'`;
for img in ${image}; do
    # some useful variables
    file_full_name=`basename ${img}`
    dir_name=`dirname ${img}`
    file_name=${file_full_name%.*}
    file_suffix_name=${file_full_name##*.}
    ## your batch commands
    # for example
    # convert -resize 640x480! ${img} ${dir_name}/${file_name}_crop.png
done
# copy finished files to your destination directory
mkdir -p ${batchDir}
rsync -av --exclude=".*" ${dataDir}/* ${batchDir}
