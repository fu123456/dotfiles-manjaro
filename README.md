
# Table of Contents

1.  [Dotfiles for Manjaro](#org89a0785)
2.  [Install dependencies](#org9a3c935)
    1.  [Emacs](#org38e1e46)
    2.  [percol](#org9e07fae)


<a id="org89a0785"></a>

# Dotfiles for Manjaro

This is my dotfiles, mainly for these tools,
vim, emacs, oh-my-zsh, tmux, percol.
My system is Manjaro (archlinux).
If you any question ,please contact me.
My email: xyzgfu@gmail.com, xyzgfu@outlook.com


<a id="org9a3c935"></a>

# Install dependencies


<a id="org38e1e46"></a>

## Emacs

If use Archlinux (Manjaro) system, you can install newest emacs by following command,

    yaourt -S emacs-git


<a id="org9e07fae"></a>

## percol

    git clone git://github.com/mooz/percol.git
    cd percol
    sudo python setup.py install

If you don't have a root permission (or don't wanna install percol with sudo), try next one.

    python setup.py install --prefix=~/.local
    export PATH=~/.local/bin:$PATH
