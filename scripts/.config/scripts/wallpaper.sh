#!/bin/bash

#*
# This script downloads an image from the given link and generates fade & blur
# transitions for it.
#
# Dependencies: feh, imagemagick, wget, bc, dunstify (optional)
#
# Default URL downloads a random image from Unsplash's curated collections
# Unsplash Source API: https://source.unsplash.com/
#*

# Variables

STEPS=5
TIME=0.02
BLUR_INTENSITY=2.4

VERBOSE=false

NOTIFICATIONS=true
NOTIFICATION_WIDTH=32

DIR=/home/$USER/.local/share/wallpaper

URL='https://source.unsplash.com/random/1920x1080/?black-background,city,space'

mkdir -p $DIR

function verbose_echo {
	if [[ $VERBOSE = true ]]; then
		printf '%s\n' "$1"
	fi
}

function dunst {
	dunstify -r 432 -a 'Wallpaper script' -t 5000 -u low -i computer "$1" "$2"
}

function send_notification {
	if [[ $NOTIFICATIONS = true ]]; then
		count=$((count+1))
		str=$(printf "%$(($count * $NOTIFICATION_WIDTH / (3 + $STEPS)))s")
		dunst "$1" "${str// /─}" &
	fi
}

# Download a new wallpaper

send_notification 'Downloading wallpaper...'

verbose_echo 'Downloading new wallpaper...'

if [ "$VERBOSE" = true ]; then
	wget -O $DIR/wallpaper_new.jpg $URL
else
	wget -q -O $DIR/wallpaper_new.jpg $URL
fi

verbose_echo 'Download finished!'

# Generate a transition for the new wallpaper

mkdir -p $DIR/transition_new

for ((i = 0; i <= $STEPS; i++)); do
	send_notification 'Generating transition...'

	T=$(printf '%s\n' 'scale=0; '$i' * (100 / '$STEPS')' | bc -l)

	verbose_echo 'Generating transition: '$T'%'

	A=$(printf '%s\n' 'scale=2; ('$T' * 0.1 + 1) * '$BLUR_INTENSITY | bc -l)
	B=$(printf '%s\n' 'scale=2; '$A' * 0.5' | bc -l)

	convert $DIR/wallpaper_new.jpg \
		-fill black -colorize $T% -blur $A,$B \
		$DIR/transition_new/$i.jpg
done

# Run the old transition if it exists

if [ -d $DIR/transition ]; then
	for (( i = 0; i <= $STEPS; i++ )); do
		verbose_echo 'Transition (out): '$i'/'$STEPS

		feh --bg-fill $DIR/transition/$i.jpg
		sleep $TIME
	done

	# Remove the old wallpaper and its transition

	verbose_echo 'Removing old files...'

	rm $DIR/wallpaper.jpg
	rm -r $DIR/transition
fi

# Rename new wallpaper and its transition

verbose_echo 'Renaming new files...'

mv $DIR/wallpaper_new.jpg $DIR/wallpaper.jpg
mv $DIR/transition_new $DIR/transition

# Run the new transition

for (( i = $STEPS; i >= 0; i-- )); do
	verbose_echo 'Transition (in): '$(($STEPS - $i))'/'$STEPS

	feh --bg-fill $DIR/transition/$i.jpg
	sleep $TIME
done

feh --bg-fill $DIR/wallpaper.jpg

send_notification 'Wallpaper set!'
