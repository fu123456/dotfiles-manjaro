#!/bin/bash
fullfilename=$1
filename="${fullfilename%.*}"
pdflatex -synctex=1 -interaction=nonstopmode  ${filename}.tex
if [ -f "${filename}.pdf" ]; then
    echo "ps2pdf to current pdf file"
    ps2pdf ${filename}.pdf ${filename}_ps2pdf.pdf
    echo "Have been sucessfully converted PS to PDF"
else
    echo "have no pdf file"
fi
