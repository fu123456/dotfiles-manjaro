#!/usr/bin/env bash
set -e
CURRENT_DIR=`pwd`
ask() {
    # http://djm.me/ask
    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question
        read -p "$1 [$prompt] " REPLY

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi
        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

dir=`pwd`
if [ ! -e "${dir}/$(basename $0)" ]; then
    echo "Script not called from within repository directory. Aborting."
    exit 2
fi
dir="${dir}/.."

distro=`lsb_release -si`
if [ ! -f "dependencies-${distro}" ]; then
    echo "Could not find file with dependencies for distro ${distro}. Aborting."
    exit 2
fi

ask "Install packages?" Y && bash ./dependencies-${distro}

# Backup you dotfiles
echo "Backing up current vim config"
today=`date +%Y-%m-%d-%H-%M`
for i in $HOME/.vim $HOME/.emacs.d $HOME/.vimrc $HOME/.gvimrc $HOME/.vimrc.bundles $HOME/.spacemacs $HOME/.bashrc $HOME/.zshrc $HOME/.xinitrc $HOME/.Xresources $HOME/.xprofile $HOME/.tmux.conf $HOME/.i3 $HOME/.percol.d $HOME/scripts $HOME/.gitconfig $HOME/.gitignore;
do [ -e $i ] && [ ! -L $i ] && mv $i $i.$today;
done
for i in $HOME/.vim $HOME/.emacs.d $HOME/.vimrc $HOME/.gvimrc $HOME/.vimrc.bundles $HOME/.spacemacs $HOME/.bashrc $HOME/.zshrc $HOME/.xinitrc $HOME/.Xresources $HOME/.xprofile $HOME/.tmux.conf $HOME/.i3 $HOME/.percol.d $HOME/scripts $HOME/.gitconfig $HOME/.gitignore;
do [ -L $i ] && unlink $i;
done

ask "Install symlink for .gitconfig?" Y && ln -sfn ${dir}/.gitconfig ${HOME}/.gitconfig
ask "Install symlink for .bashrc?" Y && ln -sfn ${dir}/.bashrc ${HOME}/.bashrc
ask "Install symlink for .vimrc?" Y && ln -sfn ${dir}/.vimrc ${HOME}/.vimrc
ask "Install symlink for .vimrc.bundles?" Y && ln -sfn ${dir}/.vimrc.bundles ${HOME}/.vimrc.bundles
ask "Install symlink for .Xresources?" Y && ln -sfn ${dir}/.Xresources ${HOME}/.Xresources
ask "Install symlink for .xinitrc?" Y && ln -sfn ${dir}/.xinitrc ${HOME}/.xinitrc
ask "Install symlink for .xprofile?" Y && ln -sfn ${dir}/.xprofile ${HOME}/.xprofile
ask "Install symlink for .zshrc?" Y && ln -sfn ${dir}/.zshrc ${HOME}/.zshrc
ask "Install symlink for .tmux.conf?" Y && ln -sfn ${dir}/.tmux.conf ${HOME}/.tmux.conf
ask "Install symlink for .i3/?" Y && ln -sfn ${dir}/.i3 ${HOME}/.i3
ask "Install symlink for .vim/?" Y && ln -sfn ${dir}/.vim ${HOME}/.vim
ask "Install symlink for .percol.d/?" Y && ln -sfn ${dir}/.percol.d ${HOME}/.percol.d
ask "Install symlink for scripts/?" Y && ln -sfn ${dir}/scripts ${HOME}/scripts

#####################################################################
# Install oh-my-zsh
#####################################################################

wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
# replace bash to zsh
chsh -s /bin/zsh
# link .zshrc file
# lnif "$CURRENT_DIR/.zshrc" "$HOME/.zshrc" #如果建立软连接，oh my zsh终端显示会失败，在安装默认的.zshrc文件中进行修改，而不要进行软连接
#install pipeline fonts, if not, the theme is messy
if [ ! -d "/usr/share/fonts/OTF" ]; then
    sudo mkdir -p /usr/share/fonts/OTF
fi
wget https://raw.githubusercontent.com/powerline/powerline/develop/font/10-powerline-symbols.conf
wget https://raw.githubusercontent.com/powerline/powerline/develop/font/PowerlineSymbols.otf
sudo cp 10-powerline-symbols.conf /usr/share/fonts/OTF/
sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/
sudo mv PowerlineSymbols.otf /usr/share/fonts/OTF/

#######################################################################

# After .vim has been symlinked!
echo "Install/upgrade vundle"
echo "Remove old plugins"
sudo rm -rf $HOME/.vim/bundle/*
sudo git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
cd "$HOME/.vim/bundle/vundle" && sudo git pull origin master # it does not work, need to firstly remove old Vundle plugin.
echo "Update/install plugins using Vundle"
system_shell=$SHELL
export SHELL="/bin/sh"
vim -N -u  $HOME/.vimrc.bundles +BundleInstall! +BundleClean +qall
export SHELL=$system_shell
echo "Finish installing vim"

##########################################################
###################spacemacs##############################
##########################################################

# Install spacemacs
# Install auctex
cd ~
wget -c http://ftp.gnu.org/pub/gnu/auctex/auctex-12.1.tar.gz
tar -xzvf auctex-12.1.tar.gz
cd auctex-12.1
./configure --prefix=$HOME/.emacs.d/site-lisp/auctex --with-lispdir=$HOME/.emacs.d/site-lisp/auctex --with-texmf-dir=$HOME/.local/lib/texmf &&
make &&
sudo make install
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
