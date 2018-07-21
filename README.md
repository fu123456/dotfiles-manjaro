
# Table of Contents

1.  [Dotfiles for Manjaro](#org9b611a2)
2.  [Install](#org2e1fff4)
    1.  [percol](#orgcb208cb)


<a id="org9b611a2"></a>

# Dotfiles for Manjaro

This is my dotfiles, mainly for these tools,
vim, emacs, oh-my-zsh, tmux, percol.
My system is Manjaro (archlinux).
If you any question ,please contact me.
My email: xyzgfu@gmail.com, xyzgfu@outlook.com


<a id="org2e1fff4"></a>

# Install


<a id="orgcb208cb"></a>

## percol

    git clone git://github.com/mooz/percol.git
    cd percol
    sudo python setup.py install

If you don't have a root permission (or don't wanna install percol with sudo), try next one.

    python setup.py install --prefix=~/.local
    export PATH=~/.local/bin:$PATH
