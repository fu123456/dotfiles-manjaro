#!/bin/bash

dir=`pwd`
if [ ! -e "${dir}/$(basename $0)" ]; then
    echo "Script not called from within repository directory. Aborting."
    exit 2
fi
dir="${dir}/.."

lnif() {
    if [ -e "$1" ]; then
        ln -sf "$1" "$2"
    fi
}

echo "Backing up current vim config"
today=`date +%Y%m%d`
for i in $HOME/.vim $HOME/.vimrc $HOME/.gvimrc $HOME/.vimrc.bundles;
do [ -e $i ] && [ ! -L $i ] && mv $i $i.$today;
done
for i in $HOME/.vim $HOME/.vimrc $HOME/.gvimrc $HOME/.vimrc.bundles; do [ -L $i ] && unlink $i ; done

echo "Setting up symlinks"
lnif ${dir}/.vimrc $HOME/.vimrc
lnif ${dir}/.vimrc.bundles $HOME/.vimrc.bundles
lnif ${dir}/.vim $HOME/.vim

echo "Install/upgrade vundle"
echo "Remove old plugins"
sudo rm -rf ${dir}/.vim/bundle/*
git clone https://github.com/gmarik/vundle.git ${dir}/.vim/bundle/vundle
cd "$HOME/.vim/bundle/vundle" && sudo git pull origin master # it does not work, need to firstly remove old Vundle plugin.

echo "Update/install plugins using Vundle"
system_shell=$SHELL
export SHELL="/bin/sh"
vim -N -u  $HOME/.vimrc.bundles +BundleInstall! +BundleClean +qall
export SHELL=$system_shell

echo "Install done"
echo "You can start vim to ensure installation that is successfully"
