# Oh My Zsh paths

export ZSH=/usr/share/oh-my-zsh
export ZSH_CUSTOM=~/.config/oh-my-zsh

# Updates

export DISABLE_AUTO_UPDATE="false"
export UPDATE_ZSH_DAYS=13

# Looks

ZSH_THEME="powerlevel9k/powerlevel9k"

POWERLEVEL9K_MODE='nerdfont-complete'

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=false
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR="\uE0B0"
POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR="\uE0B1"
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR="\uE0B2"
POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR="\uE0B3"

POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE=true
POWERLEVEL9K_STATUS_CROSS=true

POWERLEVEL9K_SHOW_CHANGESET=true
POWERLEVEL9K_CHANGESET_HASH_LENGTH=6
POWERLEVEL9K_SHORTEN_DIR_LENGTH=3

POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1
# POWERLEVEL9K_EXECUTION_TIME_ICON="\u23F1"

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon root_indicator context dir_writable dir)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs command_execution_time vcs time ssh)

POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="╭"
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="╰\uF460 "

POWERLEVEL9K_TIME_FORMAT="%D{%H:%M} \uF017"

DISABLE_LS_COLORS="false"
DISABLE_AUTO_TITLE="false"

# Completion

CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="true"
COMPLETION_WAITING_DOTS="false"

ENABLE_CORRECTION="true"

# Plugins

plugins=(
	git
	colored-man-pages
	dircycle
)

# Load Oh My Zsh

source $ZSH/oh-my-zsh.sh

# Environment variables

export GOPATH=${HOME}/go

# Aliases

alias cp="cp -i"
alias df='df -h'
alias free='free -h'

alias la='ls -la --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
alias ll='ls -l --group-directories-first --time-style=+"%d.%m.%Y %H:%M" --color=auto -F'
