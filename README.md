
# Table of Contents

1.  [Dotfiles for Manjaro](#org5a14d8e)
2.  [Install dependencies](#org88b475b)
    1.  [Emacs](#orgd4faf13)
    2.  [percol](#org79c03cf)
    3.  [Oh-my-zsh](#org769a16b)


<a id="org5a14d8e"></a>

# Dotfiles for Manjaro

This is my dotfiles, mainly for these tools,
vim, emacs, oh-my-zsh, tmux, percol.
My system is Manjaro (archlinux).
If you any question ,please contact me.
My email: xyzgfu@gmail.com, xyzgfu@outlook.com


<a id="org88b475b"></a>

# Install dependencies


<a id="orgd4faf13"></a>

## Emacs

If use Archlinux (Manjaro) system, you can install newest emacs by following command,

    yaourt -S emacs-git


<a id="org79c03cf"></a>

## percol

    git clone git://github.com/mooz/percol.git
    cd percol
    sudo python setup.py install

If you don't have a root permission (or don't wanna install percol with sudo), try next one.

    python setup.py install --prefix=~/.local
    export PATH=~/.local/bin:$PATH


<a id="org769a16b"></a>

## Oh-my-zsh

You can refer to official site: [Oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
Please also refer to my install script file: dotfiles-manjaro/setup/oh-my-zsh.sh
My install script is as follow,

    echo "Install oh-my-zsh ..."
    wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
    # replace bash to zsh
    chsh -s /bin/zsh

    # powerline-symbol font need to be installed
    if [ ! -d "/usr/share/fonts/OTF" ]; then
        sudo mkdir -p /usr/share/fonts/OTF
    fi
    wget https://raw.githubusercontent.com/powerline/powerline/develop/font/10-powerline-symbols.conf
    wget https://raw.githubusercontent.com/powerline/powerline/develop/font/PowerlineSymbols.otf
    sudo cp 10-powerline-symbols.conf /usr/share/fonts/OTF/
    sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/
    sudo mv PowerlineSymbols.otf /usr/share/fonts/OTF/

    # config file: ~/.zshrc
    # you can edit default config file, but you also can link your private config file
    # ln -sf <your .zshrc file> ~/.zshrc
    # Finally, reboot your computer
