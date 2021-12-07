#!/bin/sh

# Require desired rotation as an argument
if [ -z "$1" ]; then
    echo >&2 "Error: desired rotation not provided."
    exit 1
fi

# Get connected displays that support the desired rotation
displays=($(xrandr | grep " connected " | grep "$1" | awk '{ print $1 }'))

# Check if supported displays are connected
if [ "${#displays[@]}" == "0" ]; then
    echo >&2 "Error: no connected displays support '$1' orientation."
    exit 1
fi

# Try setting desired orientation for each display
for display in ${displays[@]}; do
    xrandr --output "${display}" --rotate "$1"
done
