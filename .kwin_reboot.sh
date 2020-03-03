#!/bin/sh

# Sometimes KWin glitches out and hogs a lot of resources.
# This is a simple helper script to restart it.

# Set display variable for KWin
DISPLAY=":0.0"

# Replace KWin and surpress the command output
kwin_x11 --replace &>/dev/null &

# Disown the background process
disown
