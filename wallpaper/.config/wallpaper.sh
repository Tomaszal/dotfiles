#!/bin/bash

# Variables

img_number=3
img_filter='(?!imgur.com\/gallery)(imgur.com\|.jpg\|.jpeg\|.png)'
sub_reddit='earthporn spaceporn skyporn itookapicture picturechallenge photocritique'
agent_name='image_pulling'

# Check for internet connection

if ! ping -q -c 1 -W 120 google.com >/dev/null; then
	echo 'No internet connection.'
	exit 1
fi

# Choose a random subreddit

sub_reddit=($sub_reddit)
sub_reddit=${sub_reddit[ $RANDOM % ${#sub_reddit[@]} ]}

# Fetch a set number of images from the chosen subreddit

image=$(curl -s -A $agent_name https://www.reddit.com/r/$sub_reddit/.json | tr '{' '\n' | grep 'author_flair_text' | tr ',' '\n' | grep 'url'| grep -m $img_number $img_filter | sed 's/"url": //' | tr -d '"')

# Choose a random picture

image=($image)
image=${image[ $RANDOM % ${#image[@]} ]}

# Fix Imgur links

[[ $image =~ \/imgur.com\/ ]] && image=$(echo $image | sed 's/imgur.com/i.imgur.com/').jpg

# Set the background and output chosend subreddit and image link

feh --bg-fill $image
echo /r/$sub_reddit/ : $image

exit 0
