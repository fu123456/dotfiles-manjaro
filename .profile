# export QT_QPA_PLATFORMTHEME="qt5ct"
# export EDITOR=/usr/bin/nano
# export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
# fix "xdg-open fork-bomb" export your preferred browser from here
export BROWSER=/usr/bin/palemoon

# exwm
# see @ https://github.com/ch11ng/exwm/wiki/Configuration-Example
[ -z "$DISPLAY" -a "$(tty)" = '/dev/tty5' ] && exec xinit -- vt05

# Avoiding input Chinese for emacs
export LC_CTYPE="en_US.UTF-8"
