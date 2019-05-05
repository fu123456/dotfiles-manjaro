#!/bin/bash
mkfifo /tmp/llpp.remote
llpp -remote /tmp/llpp.remote /home/fg/MEGA/2019ACMMM/main.pdf & disown
sleep 1
echo reload >/tmp/llpp.remote
