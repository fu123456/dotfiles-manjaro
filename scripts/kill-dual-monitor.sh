#!/bin/bash

eval `\`dirname -- "$0"\`/monitor_resolutions.sh`
expected_monitors=2
if [ "${monitor_count:-0}" -ne "$expected_monitors" ]
then
    echo "$0: Expected ${expected_monitors} monitors; found ${monitor_count:-0}." >&2
    exit 1
fi
xrandr --output "$monitor2_name" --off
