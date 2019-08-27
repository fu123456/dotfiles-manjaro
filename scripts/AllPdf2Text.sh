#!/bin/bash
# This script is to convert all of PDF files in a directory to text files in a target directory.
# Then I can do search for all test files using rgrep or lgrep in Emacs
data_dir='/home/fg/MEGA/bibtex-pdfs/'
target_dir='/home/fg/Temp/pdf2text_fg/'
# mkdir target directory
if [ ! -f "${target_dir}" ]; then
    echo "mkdir the target directory ..."
    mkdir -p ${target_dir}
else
    echo "the target directory exist !!!"
fi

for f in ${data_dir}/*.pdf; do
    filename=`basename ${f}`
    echo ${filename}
    name=${filename%.*}
    # convert to text format files
    pdftotext ${f} ${target_dir}/${name}.text
done
