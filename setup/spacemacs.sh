#!/bin/bash

echo "Installing auctex..."
cd ~
wget -c http://ftp.gnu.org/pub/gnu/auctex/auctex-12.1.tar.gz
tar -xzvf auctex-12.1.tar.gz
cd auctex-12.1
# ./configure --prefix=$HOME/.emacs.d/site-lisp/auctex --with-lispdir=$HOME/.emacs.d/site-lisp/auctex --with-texmf-dir=$HOME/.local/lib/texmf &&
./configure
make &&
sudo make install
cd ~ && rm -rf ./auctex-12.1 && rm -rf ./auctex-12.1.tar.gz

# Backup you dotfiles
echo "Backing up current vim config"
today=`date +%Y-%m-%d-%H-%M`
for i in $HOME/.emacs.d $HOME/.spacemacs;
do [ -e $i ] && [ ! -L $i ] && mv $i $i.$today;
done
for i in $HOME/.emacs.d $HOME/.spacemacs;
do [ -L $i ] && unlink $i;
done

##########################################################
###################spacemacs##############################
##########################################################
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
###########################################################
