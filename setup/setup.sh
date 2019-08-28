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
ask "Install config vim and install vim plugins?"  Y && bash ./vim.sh
ask "Install spacemacs?" Y && bash ./spacemacs.sh

# Backup you dotfiles
echo "Back your important dot config file ..."
today=`date +%Y-%m-%d-%H-%M`
for i in $HOME/.bashrc $HOME/.zshrc $HOME/.xinitrc $HOME/.Xresources $HOME/.xprofile $HOME/.tmux.conf $HOME/.i3 $HOME/.percol.d $HOME/scripts $HOME/.gitconfig $HOME/.gitignore;
do [ -e $i ] && [ ! -L $i ] && mv $i $i.$today;
done
for i in $HOME/.bashrc $HOME/.zshrc $HOME/.xinitrc $HOME/.Xresources $HOME/.xprofile $HOME/.tmux.conf $HOME/.i3 $HOME/.percol.d $HOME/scripts $HOME/.gitconfig $HOME/.gitignore;
do [ -L $i ] && unlink $i;
done

echo "Ask you for linking ..."
ask "Install symlink for .gitconfig?" Y && ln -sfn ${dir}/.gitconfig ${HOME}/.gitconfig
ask "Install symlink for .gitignore?" Y && ln -sfn ${dir}/.gitignore ${HOME}/.gitignore
ask "Install symlink for .bashrc?" Y && ln -sfn ${dir}/.bashrc ${HOME}/.bashrc
ask "Install symlink for .Xresources?" Y && ln -sfn ${dir}/.Xresources ${HOME}/.Xresources
ask "Install symlink for .xinitrc?" Y && ln -sfn ${dir}/.xinitrc ${HOME}/.xinitrc
ask "Install symlink for .xprofile?" Y && ln -sfn ${dir}/.xprofile ${HOME}/.xprofile
ask "Install symlink for .tmux.conf?" Y && ln -sfn ${dir}/.tmux.conf ${HOME}/.tmux.conf
ask "Install symlink for .i3/?" Y && ln -sfn ${dir}/.i3 ${HOME}/.i3
ask "Install symlink for .percol.d/?" Y && ln -sfn ${dir}/.percol.d ${HOME}/.percol.d
ask "Install symlink for scripts/?" Y && ln -sfn ${dir}/scripts ${HOME}/scripts
