#!/bin/bash

pos="$1"
pdffile="$2"
zathura --synctex-forward "$pos" "$pdffile" || \
    (
    zathura -x "emacsclient --eval '(progn (switch-to-buffer (file-name-nondirectory \"%{input}\")) (goto-line %{line}))'" "$pdffile" &
    sleep 1; zathura --synctex-forward "$pos" "$pdffile" )
