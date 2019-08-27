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

echo "Install oh-my-zsh ..."
wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
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

echo "Backing up current zsh config"
today=`date +%Y%m%d`
for i in $HOME/.zshrc;
do [ -e $i ] && [ ! -L $i ] && mv $i $i.$today;
done
for i in $HOME/.zshrc;
do [ -L $i ] && unlink $i;
done

# ln zshrc files
lnif ${dir}/zshrc $HOME/.zshrc

# convert bash to zsh
echo "convert bash to zsh"
chsh -s ${which zsh}

# finally, reboot computer
# sudo reboot -h now
echo "sudo reboot your compute ..."
