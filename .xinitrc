#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

DEFAULT_SESSION='i3 --shmlog-size 0'

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

get_session(){
	local dbus_args=(--sh-syntax --exit-with-session)
	case $1 in
		awesome) dbus_args+=(awesome) ;;
		bspwm) dbus_args+=(bspwm-session) ;;
		budgie) dbus_args+=(budgie-desktop) ;;
		cinnamon) dbus_args+=(cinnamon-session) ;;
		deepin) dbus_args+=(startdde) ;;
		enlightenment) dbus_args+=(enlightenment_start) ;;
		fluxbox) dbus_args+=(startfluxbox) ;;
		gnome) dbus_args+=(gnome-session) ;;
		i3|i3wm) dbus_args+=(i3 --shmlog-size 0) ;;
		jwm) dbus_args+=(jwm) ;;
		kde) dbus_args+=(startkde) ;;
		lxde) dbus_args+=(startlxde) ;;
		lxqt) dbus_args+=(lxqt-session) ;;
		mate) dbus_args+=(mate-session) ;;
		xfce) dbus_args+=(xfce4-session) ;;
		openbox) dbus_args+=(openbox-session) ;;
		*) dbus_args+=($DEFAULT_SESSION) ;;
	esac

	echo "dbus-launch ${dbus_args[*]}"
}

exec $(get_session)

#{{{ emacs exwm config
# Disable access control
xhost +SI:localuser:$USER

# Make Java applications aware this is a non-reparenting window manager.
export _JAVA_AWT_WM_NONREPARENTING=1

# Themes, etc
gnome-settings-daemon &

# Fallback cursor
xsetroot -cursor_name left_ptr

# Keyboard repeat rate
xset r rate 200 60

# Start Emacs
exec dbus-launch --exit-with-session emacs
#}}}

# {{{ Stop screen turn off after several minutes in i3wm
# to see @ https://www.reddit.com/r/i3wm/comments/399nr3/how_to_stop_screen_turn_off_after_several_minutes/
xset s off
xset -dpms
xset s noblank
# }}}
