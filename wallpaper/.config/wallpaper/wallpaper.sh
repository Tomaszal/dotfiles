#!/bin/bash

# Subreddits string (enter wanted subreddits separated by '+')

subreddits='earthporn+spaceporn+skyporn+itookapicture+photocritique'

# Important variables

index_file="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/index"

# Check for internet connection

if ! ping -q -c 1 -W 120 google.com > /dev/null; then
  echo "The network is down."
  exit 1
fi

# Fetch images and permalinks from the chosen subreddits

data=$(curl -s -A agent https://www.reddit.com/r/$subreddits/.json | \
	sed 's/"permalink"/\n "permalink"/g; s/"kind"/\n/g' | grep '"permalink"' | \
	grep -v 'imgur.com\/gallery' | grep -v 'imgur.com\/a\/' | \
	grep -e '.jpg' -e '.jpeg' -e '.png' | \
	tr ',' '\n' | \
	grep -e ' "permalink": ' -e ' "url": ' | \
	sed 's/ "permalink": //; s/ "url": //; s/"//g')

IFS=$'\n'
data=($data)

# Get index from the file and override it if specified with "-i" argument or if it exceeds the limits

index=$(<$index_file)

getopts :i: opt

if [[ $OPTARG =~ ^-?[0-9]+$ ]]; then
	index=$OPTARG
fi

if [ $index -ge $((${#data[@]} / 2)) ]; then
	index=0
fi

# Choose the image with the given index (and permalink to post)

echo $index
echo ${data[$((index * 2))]}
echo ${data[$((index * 2 + 1))]}

image=${data[$((index * 2 + 1))]}

# Fix Imgur links

[[ $image =~ \/imgur.com\/ ]] && image=$(echo $image | sed 's/imgur.com/i.imgur.com/').jpg

# Set the background and output chosend subreddit and image link

feh --bg-fill $image

# Write next index to the file

echo $((index + 1)) > "$index_file"

exit 0
