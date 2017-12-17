#!/bin/bash

# Variables

MAX_VOLUME='100'

SOUND_ICON_0='  '
SOUND_ICON_1='  '

BAR_WIDTH='10'
BAR_INDICATOR="%{F#FF0000}|%{F-}"
BAR_FILL='-'
BAR_EMPTY='-'

# Method to update status variables

function update {
	sink=$(pacmd list-sinks | awk '/* index:/{print $3}')

	volume=$(pacmd list-sinks | grep -A 15 "index: $sink$" | grep 'volume:' | grep -E -v 'base volume:' | awk -F : '{print $3}' | grep -o -P '.{0,3}%'| sed s/.$// | tr -d ' ')

	mute=$(pacmd list-sinks | grep -A 15 "index: $sink$" | awk '/muted/{ print $2}')
}

# Methods for script operations

function setMute {
	case "$1" in
		on)
			pactl set-sink-mute "$sink" 1
			;;
		off)
			pactl set-sink-mute "$sink" 0
			;;
		toggle)
			if [[ $mute = 'yes' ]]; then
				setMute 'off'
			else
				setMute 'on'
			fi
			;;
		*)
			printf 'Usage:\tvolume.sh --mute <on/off/toggle>\n'
			exit
			;;
	esac
}

function setVolume {
	if [[ -z $1 ]]; then
		printf 'Usage:\tvolume.sh --volume <+X/-X>\n'
		exit
	fi

	volume=$(echo "$volume $1" | bc -l)

	if [[ $volume -ge $MAX_VOLUME ]]; then
		volume=$MAX_VOLUME
	elif [[ $volume -le 0 ]]; then
		volume='0'
	fi

	pactl set-sink-volume "$sink" "$volume%"
}

function output {
	case "$1" in
		print)
			update

			if [[ $mute = 'yes' ]]; then
				printf '%s' "$SOUND_ICON_0"
			else
				printf '%s' "$SOUND_ICON_1"
			fi

			if  [[ -z $2 ]]; then
				printf '%s' $volume'%'
			else
				indicator=$(($volume*$BAR_WIDTH/$MAX_VOLUME))

				for ((i = 0; i <= $BAR_WIDTH; i++)); do
					if [[ $i -lt $indicator ]]; then
						printf '%s' "$BAR_FILL"
					elif [[ $i -gt $indicator ]]; then
						printf '%s' "$BAR_EMPTY"
					else
						printf '%s' "$BAR_INDICATOR"
					fi
				done
			fi

			printf '\n'
			;;
		listen)
			output 'print' $2

			pactl subscribe 2>/dev/null | {
				while true; do
					read -r event || break

					if [[ $event == *'on sink #'$sink* ]]; then
						output 'print' $2
					fi
				done
			}
			;;
		*)
			printf 'Usage:\tvoluem.sh --output <print/listen> [bar]\n'
			exit
			;;
	esac
}

# Initiate the script

update

case "$1" in
	--mute)
		setMute $2
		;;
	--volume)
		setVolume $2
		;;
	--output)
		output $2 $3
		;;
	*)
		printf 'Usage:\tvolume.sh <operation> [...]\n'
		printf 'Operations:\n'
		printf '\t--mute <on/off/toggle>\n'
		printf '\t--volume <+X/-X>\n'
		printf '\t--output <print/listen> [bar]\n'
		exit
		;;
esac
