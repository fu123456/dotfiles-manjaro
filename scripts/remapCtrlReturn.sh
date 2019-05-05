#!/bin/bash

# # assign return to control on press, return on release
# xmodmap -e 'keycode 36 = 0x1234'
# xmodmap -e 'add Control = 0x1234'
# # maek a fake return key (so we can map it with xcape)
# xmodmap -e 'keycode any = Return'
# xcape -e '0x1234 = Return'

#{{{ remap Control to Return
# see @ http://emacsredux.com/blog/2016/01/30/remap-return-to-control-in-gnu-slash-linux/
xmodmap -e "remove Control = Control_R"
xmodmap -e "keycode 0x69 = Return"
xmodmap -e "keycode 0x24 = Control_R"
xmodmap -e "add Control = Control_R"
xcape -t 10000 -e "Control_R=Return"
#}}}
