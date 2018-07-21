# Dotfiles for Manjaro
This is my dotfiles, mainly for these tools,
vim, emacs, oh-my-zsh, tmux, percol.
My system is Manjaro (archlinux).
If you any question ,please contact me.
My email: xyzgfu@gmail.com, xyzgfu@outlook.com
# Install
## percol
``` shell
git clone git://github.com/mooz/percol.git
cd percol
sudo python setup.py install
```
If you don't have a root permission (or don't wanna install percol with sudo), try next one.
``` shell
python setup.py install --prefix=~/.local
export PATH=~/.local/bin:$PATH

```
