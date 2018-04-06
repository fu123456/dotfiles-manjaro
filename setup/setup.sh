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
ask "Install symlink for .gitignore?" Y && ln -sfn ${dir}/.gitignore ${HOME}/.gitignore
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
