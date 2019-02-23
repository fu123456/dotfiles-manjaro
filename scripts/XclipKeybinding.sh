#!/bin/bash
sh -c 'sleep 0.5; xdotool type "$(xclip -o -selection clipboard)"'
