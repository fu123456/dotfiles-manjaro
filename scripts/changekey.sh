#!/usr/bin/env bash

# depends xmodmap xcape
# https://github.com/alols/xcape
# this script is very useful
# Control_L <-> ESC
# Enter <-> Control
# clear allmappings:
setxkbmap -option ''
# assign return to control on press, return on release
xmodmap -e 'clear Lock'
xmodmap -e 'keycode 66 = Control_L'
xmodmap -e 'add Control = Control_L'
# make a fake escape key (so we can map it with xcape)
xmodmap -e 'keycode 999 = Escape'
xcape -e 'Control_L=Escape'
# assign return to control on press, return on release
xmodmap -e 'keycode 36 = 0x1234'
xmodmap -e 'add Control = 0x1234'
# make a fake return key (so we can map it with xcape)
xmodmap -e 'keycode any = Return'
xcape -e '0x1234=Return'   
# 会存在在vim按下Capslock键时要停留很短暂的时间
# 如果操作速度太快，就会Capslock就会被作为
# 组合键来使用。
# my add, convert caps to ctrl
setxkbmap -option "ctrl:nocaps"
synclient TouchpadOff=1

# Emacs
# emacs-snapshot --daemon 
# emacsclient -nc

# close screen clock
xset -dpms s off
