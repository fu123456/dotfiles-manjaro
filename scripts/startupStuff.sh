#!/bin/bash
echo "grasp for org capture"
python /home/fg/Install/grasp/server/grasp_server.py --path /home/fg/MEGA/org/bookmark.org  --template  $'** [[%:link][%:description]] %:tags\n%U\n' &
echo "xkeysnail for keymap config"
echo fugang | sudo -S xkeysnail /home/fg/MEGA/dotfiles-manjaro/scripts/config_xkeysnail.py &
