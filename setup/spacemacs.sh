#!/bin/bash

dir=`pwd`
if [ ! -e "${dir}/$(basename $0)" ]; then
    echo "Script not called from within repository directory. Aborting."
    exit 2
fi
dir="${dir}/.."

# Backup you dotfiles
echo "Backing up current emacs config"
today=`date +%Y-%m-%d-%H-%M`
for i in $HOME/.emacs.d $HOME/.spacemacs;
do [ -e $i ] && [ ! -L $i ] && mv $i $i.$today;
done
for i in $HOME/.emacs.d $HOME/.spacemacs;
do [ -L $i ] && unlink $i;
done

# Install spacemacs
today=`date +%Y-%m-%d-%H-%M`
if [ ! -d $HOME/.emacs.d ];then
    mkdir -p $HOME/.emacs.d
else
    cd ~
    mv .emacs.d .emacs.d-${today}
    mkdir -p $HOME/.emacs.d
fi
echo "clone spacemacs"
git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
echo "Backing up current emacs config"
for i in $HOME/.spacemacs $HOME/.emacs.d/init.el $HOME/.emacs.d/private;
do [ -e $i ] && [ ! -L $i ] && mv $i $i.$today;
done
for i in $HOME/.spacemacs $HOME/.emacs.d/init.el $HOME/.emacs.d/private; do [ -L $i ] && unlink $i ; done
ln -sfn ${dir}/.emacs.d/init.el ${HOME}/.emacs.d/init.el
ln -sfn ${dir}/.spacemacs ${HOME}/.spacemacs
ln -sfn ${dir}/.emacs.d/private ${HOME}/.emacs.d/private
echo "Please start your emacs to install spacemacs plugins ..."
