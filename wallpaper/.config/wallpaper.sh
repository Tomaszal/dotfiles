#!/bin/bash

#*
# This script downloads an image from the given link and generates fade & blur
# transitions for it.
#
# Dependencies: feh, imagemagick, wget
#
# Default URL downloads a random image from Unsplash's curated collections
# Unsplash Source API: https://source.unsplash.com/
#*

# Variables

STEPS=10
TIME=0.01
INTENSITY=4.8

VERBOSE=true

DIR=/home/$USER/.local/share/wallpaper

URL="https://source.unsplash.com/featured/1920x1080"

mkdir -p $DIR

function verbose_echo {
	if [ "$VERBOSE" = true ]; then echo -e $1; fi
}

# Download a new wallpaper

verbose_echo "Downloading new wallpaper...\n"

if [ "$VERBOSE" = true ]; then wget -O $DIR/wallpaper_new.jpg $URL
else wget -q -O $DIR/wallpaper_new.jpg $URL; fi

verbose_echo "Download finished!\n"

# Generate a transition for the new wallpaper

mkdir -p $DIR/transition_new

for (( i = 0; i <= $STEPS; i++ )); do
	T=$( echo "scale = 0; $i * (100 / $STEPS)" | bc -l )

	verbose_echo "Generating transition: $T%"

	A=$( echo "scale = 2; ($T * 0.1 + 1) * $INTENSITY" | bc -l )
	B=$( echo "scale = 2; $A * 0.5" | bc -l )

	convert $DIR/wallpaper_new.jpg \
		-fill black -colorize $T% -blur $A,$B \
		$DIR/transition_new/$i.jpg
done

verbose_echo ""

# Run the old transition if it exists

if [ -d $DIR/transition ]; then
	for (( i = 0; i <= $STEPS; i++ )); do
		verbose_echo "Transition (out): $i/$STEPS"

		feh --bg-fill $DIR/transition/$i.jpg
		sleep $TIME
	done

	# Remove the old wallpaper and its transition

	verbose_echo "\nRemoving old files...\n"

	rm $DIR/wallpaper.jpg
	rm -r $DIR/transition
fi

# Rename new wallpaper and its transition

verbose_echo "Renaming new files...\n"

mv $DIR/wallpaper_new.jpg $DIR/wallpaper.jpg
mv $DIR/transition_new $DIR/transition

# Run the new transition

for (( i = $STEPS; i >= 0; i-- )); do
	verbose_echo "Transition (in): $(($STEPS - $i))/$STEPS"

	feh --bg-fill $DIR/transition/$i.jpg
	sleep $TIME
done

feh --bg-fill $DIR/wallpaper.jpg
