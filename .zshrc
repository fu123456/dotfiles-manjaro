# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/home/fg/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git extract z last-working-dir wd redis-cli sudo wd vi-mode forklift copyfile copydir cp pj copybuffer)
PROJECT_PATHS=(~/source_codes/intrinsic_image_decomposition_source_code ~/MEGA/sync/shadow-detection)
source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

#    _   _    ___   _   ___
#   /_\ | |  |_ _| /_\ / __|
#  / _ \| |__ | | / _ \\__ \
# /_/ \_\____|___/_/ \_\___/

#set my useful alias
alias cls='clear'
alias ll='ls -l'
alias la='ls -a'
alias javac="javac -J-Dfile.encoding=utf8"
alias grep="grep --color=auto"

# 使用oh my zsh，直接输入文件名会自动使用相应程序打开
alias -s html=vi   # 在命令行直接输入后缀为 html 的文件名，会在 TextMate 中打开
alias -s htm=vi
alias -s rb=vi     # 在命令行直接输入 ruby 文件，会在 TextMate 中打开
alias -s py=vi       # 在命令行直接输入 python 文件，会用 vim 中打开，以下类似
alias -s js=vi
alias -s c=vi
alias -s cpp=vi
alias -s java=vi
alias -s txt=vi
alias -s matlab=vi
alias -s pdf=evince
alias -s tex=vi
alias -s bib=vi
alias -s md=vi
alias -s org=vi
########################################
alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s zip='unzip'
alias -s bz2='tar -xjvf'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias q='bye'
alias szsh='source ~/.zshrc'
alias Matlab='sudo /usr/local/MATLAB/R2017a/bin/matlab'
alias Mrun="sudo /usr/local/MATLAB/R2017a/bin/matlab -nodesktop -nosplash"
alias mrun="sudo /usr/local/MATLAB/R2017a/bin/matlab -nodesktop -nosplash"
alias matrun="sudo /usr/local/MATLAB/R2017a/bin/matlab -nodesktop -nodisplay -nosplash -nojvm"
alias matlab="LD_PRELOAD=/usr/lib64/libstdc++.so.6 /usr/local/MATLAB/R2017a/bin/matlab -desktop &"
alias -g vims='vim --servername vim --remote-silent'
alias -g jabref='java -jar ~/Install/JabRef-4.1.jar &'
# download all files of a directory form a website
alias -g wgetall='wget -c -r -np -k -L -p'
# simplify hard to remember command names
alias pk-show='apt-cache show'
alias install='sudo apt install'
alias update='sudo apt update'
alias remove='sudo apt remove'
alias autoremove='sudo apt autoremove'
alias sdp='sudo dpkg -i'

# my display pdf by using impressive
alias -g imp='impressive --nologo'

# ecryptfs
# 这里的work_s是加密后的文件所在的文件夹，
# 而work就是我们所放置的文件
alias mountwork="sudo mount -t ecryptfs $HOME/Work_s $HOME/Work -o ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_enable_filename_crypto=y,ecryptfs_passthrough=n,ecryptfs_fnek_sig=8bd769e2191f9f95"

# jekyll
alias jek="bundle exec jekyll serve"

# my sync: nutstore dropbox
alias dropbox="~/.dropbox-dist/dropboxd > /dev/null 2>&1 &"
alias nutstore="python ~/.nutstore/dist/bin/nutstore-pydaemon.py > /dev/null 2>&1 &"
alias lantern="/usr/bin/lantern > /dev/null 2>&1 &"
alias mega="megasync > /dev/null 2>&1 &"
alias syncall="~/Dropbox/Bashscripts/snycall"
alias killsync="killall dropbox & killall nutstore & killall megasync"
alias ss="ss-qt5 > /dev/null 2>&1 &"

#push and pull my dotfiles
alias pulldot="cd ~/.dotfiles && ./pull.sh"
alias pushdot="cd ~/.dotfiles && ./push.sh"

#emacs
# alias e="emacsclient-snapshot"
# alias ec="emacsclient-snapshot -c"
# alias et="emacsclient-snapshot -t"
alias ed="emacs-snapshot --daemon"
alias ec="emacsclient -nc"

# vimb
alias vimb="vimb > /dev/null 2>&1 &"

# close touchpad
alias ctp="synclient TouchpadOff=1"
# open touchpad
alias otp="synclient TouchpadOff=0"

# convert caps to ctrl
alias cc="setxkbmap -option "ctrl:nocaps""

# log out
alias lo="kill -9 -1"

# wechat
alias wechat="/home/fg/Install/electronic-wechat-linux-x64/electronic-wechat"

# 让emacs性能提升十倍
# two parameters: a)start; b)restore
alias emacs2ram="bash ~/Dropbox/Bashscripts/emacs2ram"

# briss, pdf crop setting
alias briss="java -jar /home/fg/Install/briss-0.9/briss-0.9.jar"

# list i3 all keybinding alias
alias i3cheatsheet='egrep ^bind ~/.config/i3/config | cut -d '\'' '\'' -f 2- | sed '\''s/ /\t/'\'' | column -ts $'\''\t'\'' | pr -2 -w 160 -t | less'

# turn off i3clock
alias i3clockoff='xset -dpms s off'
alias i3clock='xset -dpms s on'

# screen shot
# alias scrot-s='scrot -s '%H%M%S-%d_$wx$h.png' -e 'mkdir -p ~/screenshot;mv $f ~/screenshot/;echo ~/screenshot/$f|tr -d \"\\n\"|xsel -ib;''

# 关机、睡眠、休眠、挂起
# 休眠, save to disk, 要重新按开机键
alias pmh='sudo pm-hibernate'
# 挂起, save to ram, 按下键盘鼠标就行了
alias pms='sudo pm-suspend'
# 重启
alias -g rb='sudo reboot -h now'
# 关机
alias -g st='sudo shutdown -h now'

# vimgolf alias
alias vimg="vim -u .vimrc.basic"

# vi
alias vi="vim"

# change key bash shell script
alias ckey="~/MEGA/sync/Shellscripttools/changekey.sh"

# presentation of i3wm
alias pres_r="xrandr --output eDP-1 --mode 1024x768 --right-of DP-2"
alias pres="xrandr --output eDP-1 --mode 1024x768 --same-as DP-2"
alias pres_e="xrandr -s 0" # 恢复屏幕原始分辨率
alias pres_e="xrandr -s 1366x768" #恢复屏幕原始尺寸

alias ss="ss-qt5 > /dev/null 2>&1 &"

# alias
alias nets="sudo service network-manager start"
alias wicds="sudo /etc/init.d/wicd restart"

# start my softwares
alias mykey="ctp && cc && ckey"
alias myall="cc && ctp && ckey && ed && ec"

# alias for Manjaro Linux system
alias manjaroUpdate="sudo pacman -Syyu"
#  ___ _  _ ___
# | __| \| |   \
# | _|| .` | |) |
# |___|_|\_|___/


#my setting
# export PYTHONPATH=${HOME}/python:$PYTHONPATH

#export PATH=/usr/local/cuda-8.0/bin:$PATH
#export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64:$LD_LIBRARY_PATH
export PATH=/usr/local/MATLAB/R2014b/bin:$PATH
export PATH=/usr/local/MATLAB/R2014b/bin/glnxa64:$PATH
#export PATH=/usr/local/MATLAB/R2017a/bin:$PATH
#export PATH=/usr/local/MATLAB/R2017a/bin/glnxa64:$PATH
#export MATLAB_PREFDIR=/usr/local/MATLAB/R2017a/bin/matlab

prompt_context() {
    if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
        prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
    fi
}
# TeX Live 2016
export MANPATH=${MANPATH}:/urs/local/texlive/2016/texmf-dist/doc/man
export INFOPATH=${INFOPATH}:/usr/local/texlive/2016/texmf-dist/doc/info
export PATH=${PATH}:/usr/local/texlive/2016/bin/x86_64-linux

#perl
# export PERL5LIB=/home/perl_modules/lib/perl5/:/home/perl_modules/lib/perl5/site_perl:
export PERL5LIB=/usr/lib/x86_64-linux-gnu/perl:$PERL5LIB
# emacs
# export PATH=${PATH}:/home/fg/Install/emacs/src

# export PYTHONPATH=/home/fg/install/dlib-19.3/python_examples:$PYTHONPATH
# 这里的参数-2的作用是使得vim和tmux的背景颜色是一致的
# 设定tmux随终端启动而自动启动
# fugang 2016-07,但是加入下面三行代码emacs启动老友错误信息
# 所以为了正常启动emacs，把下面tmux关闭了。
# case $- in *i*)
# [ -z "$TMUX" ] && exec tmux -2
# esac

# 解决自动启动tmux时，emacs出现错误，不能输入中文的问题
# Do not use autostart, explicitly start/attach session
# https://github.com/syl20bnr/spacemacs/issues/988
# ZSH_TMUX_AUTOSTART=false
# [[ $TMUX == "" ]] && tmux new-session -A -s work

# 保存命令数目
export HISTSIZE=500000

#                       _
#  _ __  ___ _ _ __ ___| |
# | '_ \/ -_) '_/ _/ _ \ |
# | .__/\___|_| \__\___/_|
# |_|

# several useful functions:
# ppkill, kill a process
# h, 搜索历史命令
# percol_cd_history, 在历史进入的目录中搜索（目录）, 快捷键：，c
# ff, 在指定的目录下搜索文件

# percol setting
function ppgrep() {
    if [[ $1 == "" ]]; then
        PERCOL=percol
    else
        PERCOL="percol --query $1"
    fi
    ps aux | eval $PERCOL | awk '{ print $2 }'
}

function ppkill() {
    if [[ $1 =~ "^-" ]]; then
        QUERY=""            # options only
    else
        QUERY=$1            # with a query
        [[ $# > 0 ]] && shift
    fi
    ppgrep $QUERY | xargs kill -9 $*
}

# 搜索历史记录
function exists { which $1 &> /dev/null }

if exists percol; then
    function h() {
        local tac
        exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r" } }
        BUFFER=$(fc -l -n 1 | eval $tac | percol --query "$LBUFFER")
        CURSOR=$#BUFFER         # move cursor
        zle -R -c               # refresh
    }

    zle -N h
    bindkey '^R' h
fi

# oh my zsh with percol setting
# percolで履歴ジャンプ
# http://stillpedant.hatenablog.com/entry/percol-cd-history
# {{{
# cd 履歴を記録
typeset -U chpwd_functions
CD_HISTORY_FILE=${HOME}/.cd_history_file # cd 履歴の記録先ファイル
function chpwd_record_history() {
    echo $PWD >> ${CD_HISTORY_FILE}
}
chpwd_functions=($chpwd_functions chpwd_record_history)

# percol を使って cd 履歴の中からディレクトリを選択
# 過去の訪問回数が多いほど選択候補の上に来る
function percol_get_destination_from_history() {
    sort ${CD_HISTORY_FILE} | uniq -c | sort -r | \
        sed -e 's/^[ ]*[0-9]*[ ]*//' | \
        sed -e s"/^${HOME//\//\\/}/~/" | \
        percol | xargs echo
}

# percol を使って cd 履歴の中からディレクトリを選択し cd するウィジェット
function percol_cd_history() {
    local destination=$(percol_get_destination_from_history)
    [ -n $destination ] && cd ${destination/#\~/${HOME}}
    zle reset-prompt
}
zle -N percol_cd_history

# percol を使って cd 履歴の中からディレクトリを選択し，現在のカーソル位置に挿入するウィジェット
function percol_insert_history() {
    local destination=$(percol_get_destination_from_history)
    if [ $? -eq 0 ]; then
        local new_left="${LBUFFER} ${destination} "
        BUFFER=${new_left}${RBUFFER}
        CURSOR=${#new_left}
    fi
    zle reset-prompt
}
zle -N percol_insert_history
# }}}

# C-x ; でディレクトリに cd
# C-x i でディレクトリを挿入
# bindkey '^x;' percol_cd_history
# bindkey '^xi' percol_insert_history

# my keybinding
bindkey ',c' percol_cd_history
bindkey ',i' percol_insert_history

############################################################
# chenbin blog percol setting
[ $(uname -s | grep -c CYGWIN) -eq 1 ] && OS_NAME="CYGWIN" || OS_NAME=`uname -s`
function pclip() {
    if [ $OS_NAME == CYGWIN ]; then
        putclip $@;
    elif [ $OS_NAME == Darwin ]; then
        pbcopy $@;
    else
        if [ -x /usr/bin/xsel ]; then
            xsel -ib $@;
        else
            if [ -x /usr/bin/xclip ]; then
                xclip -selection c $@;
            else
                echo "Neither xsel or xclip is installed!"
            fi
        fi
    fi
}

# search the file and pop up dialog, then put the full path in clipboard
function baseff()
{
    local fullpath=$*
    local filename=${fullpath##*/} # remove "/" from the beginning
    filename=${filename##*./} # remove  ".../" from the beginning
    # Only the filename without path is needed
    # filename should be reasonable
    local cli=`find . -not -iwholename '*/vendor/*' -not -iwholename '*/bower_components/*' -not -iwholename '*/node_modules/*' -not -iwholename '*/target/*' -not -iwholename '*.svn*' -not -iwholename '*.git*' -not -iwholename '*.sass-cache*' -not -iwholename '*.hg*' -type f -path '*'${filename}'*' -print | /usr/local/bin/percol`
    # convert relative path to full path
    echo $(cd $(dirname $cli); pwd)/$(basename $cli)
}

function ff()
{
    local cli=`baseff $*`
    # echo ${cli} | sed 's%^'${HOME}'%~%'
    # echo -n ${cli}  | sed 's%^'${HOME}'%~%' | pclip
    echo ${cli}
    # echo -n ${cli} | pclip
    echo -n ${cli} | xclip -selection c
}

function cf()
{
    local cli=`baseff $*`
    local p=`cygpath -w $cli`
    echo ${p}
    echo -n ${p} | pclip;
}
#  ___ _  _ ___
# | __| \| |   \
# | _|| .` | |) |
# |___|_|\_|___/

# copy current file full name to clipboard
function copyf {
    emulate -L zsh
    print -n $PWD"/"$1 | clipcopy
}
# copy current dir name to clipboard
function copyd {
    emulate -L zsh
    print -n $PWD | clipcopy
}
# copy current file content
function copyb {
    if which clipcopy &>/dev/null; then
        echo $BUFFER | clipcopy
    else
        echo "clipcopy function not found. Please make sure you have Oh My Zsh installed correctly."
    fi
}

# 关闭触摸板
# synclient TouchpadOff=1
LC_CTYPE="zh_CN.utf8"
PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
export PKG_CONFIG_PATH
export PKG_CONFIG_PATH
export PKG_CONFIG_PATH
export PKG_CONFIG_PATH

# forklift setting
function fl {
    if [ ! -z "$1" ]; then
        DIR=$1
        if [ ! -d "$DIR" ]; then
            DIR=$(dirname $DIR)
        fi
        if [ "$DIR" != "." ]; then
            PWD=`cd "$DIR";pwd`
        fi
    fi
}

# brew setting
export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"

# added by Anaconda3 4.2.0 installer
export PATH="/home/fg/anaconda3/bin:$PATH"

# term color setting
export TERM=xterm-256color

# export my bash shell
export PATH=/home/fg/MEGA/Shellscripttools:$PATH
