#!/bin/sh

xrandr --output DP-2   --mode 2560x1440 --rate 170 --pos 1080x240 --primary \
       --output HDMI-0 --mode 1920x1080 --rate 75  --pos 0x0      --rotate left \
       --output DP-0   --off \
       --output DP-1   --off \
       --output DP-3   --off \
       --output DP-4   --off \
       --output DP-5   --off
