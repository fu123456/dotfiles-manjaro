# -*- coding: utf-8 -*-
import re
from xkeysnail.transform import *

# [Global modemap] Change modifier keys as in xmodmap
define_modmap({
    Key.CAPSLOCK: Key.LEFT_CTRL
})

# [Conditional modmap] Change modifier keys in certain applications
define_conditional_modmap(re.compile(r'Emacs'), {
    Key.RIGHT: Key.ESC,
})

# [Multipurpose modmap] Give a key two meanings. A normal key when pressed and
# released, and a modifier key when held down with another key. See Xcape,
# Carabiner and caps2esc for ideas and concept.
define_multipurpose_modmap(
    # Enter is enter when pressed and released. Control when held down.
    {Key.ENTER: [Key.ENTER, Key.RIGHT_CTRL],
     Key.CAPSLOCK: [Key.ESC, Key.LEFT_CTRL],}
    # Capslock is escape when pressed and released. Control when held down.
    #  {Key.CAPSLOCK: [Key.ESC, Key.LEFT_CTRL]}
    # To use this example, you can't remap capslock with define_modmap.
)

# config firefox and chrome apps
define_keymap(re.compile("Firefox|Google-chrome"), {
    # Ctrl+Alt+j/k to switch next/previous tab
    K("C-M-j"): K("C-TAB"),
    K("C-M-k"): K("C-Shift-TAB"),
    K("C-k"): K("C-w"),
    K("M-l"): K("C-TAB"),
    K("M-h"): K("C-Shift-TAB"),
    # K("C-s"): K("C-f"),
    K("C-h"): K("Backspace"),
    K("semicolon"): K("Backspace"),
    K("C-semicolon"): K("semicolon"),
    K("C-m"): K("Enter"),
    # very naive "Edit in editor" feature (just an example)
}, "Firefox and Chrome")

# config for Emacs app
define_keymap(re.compile("Emacs"), {
    # ; to switch Backspace
    # C-; to switch ;
    K("semicolon"): K("Backspace"),
    K("C-semicolon"): K("semicolon"),
}, "Emacs")

define_keymap(re.compile("Gnome-terminal|URxvt|Vmplayer|FocusProxy|Skype"), {
    # ; to switch Backspace
    # C-; to switch ;
    K("semicolon"): K("Backspace"),
    K("C-semicolon"): K("semicolon"),
    K("C-m"): K("Enter"),
    K("C-g"): K("Esc"),
}, "URxvt and Vmplayer and FocusProxy")

define_keymap(re.compile("Goldendict"), {
    # ; to switch Backspace
    # C-; to switch ;
    K("semicolon"): K("Backspace"),
    K("C-semicolon"): K("semicolon"),
    K("C-m"): K("Enter"),
    K("C-g"): K("Esc"),
    # Page up/down
    K("C-k"): with_mark(K("up")),
    K("C-j"): with_mark(K("down")),
}, "Goldendict")

define_keymap(lambda wm_class: wm_class not in ("Emacs", "URxvt"), {
    # Newline
    K("C-m"): K("enter"),
    # Search
    K("C-s"): K("F3"),
    # Cancel
    K("C-g"): [K("esc"), set_mark(False)],
    # convert ; to backspace
    K("semicolon"): K("Backspace"),
    K("C-semicolon"): K("semicolon"),
}, "Fugang keys")
