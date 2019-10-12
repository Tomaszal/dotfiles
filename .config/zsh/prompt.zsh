# ----------------------------------------
# > Zsh Powerline Prompt Theme (ZPPT)
# ----------------------------------------

# Left segment and subsegment separators
ZPPT_L_SEP="\uE0B0"
ZPPT_L_SSEP="\uE0B1"

# Right segment and subsegment separators
ZPPT_R_SEP="\uE0B2"
ZPPT_R_SSEP="\uE0B3"

# Trunctate directories if exceed this limit (0 to not trunctate)
ZPPT_DIR_MAX=3

# ----------------------------------------
# > Prompt setup
# ----------------------------------------

# Substitute and expand commands in prompt
setopt PROMPT_SUBST

# Remove indentation after zsh right prompt
# ZLE_RPROMPT_INDENT=-1

# Assign prompt variables
PROMPT='$(zppt_prompt)'
PROMPT2='$(zppt_prompt2)'
PROMPT3='$(zppt_prompt3)'
RPROMPT='$(zppt_rprompt)'
RPROMPT2=''
SPROMPT='$(zppt_sprompt)'

# Prompt precommand function
zppt_precmd() {
	RETVAL=$?
}

# Attach the hook function
autoload -U add-zsh-hook
add-zsh-hook precmd zppt_precmd

# ----------------------------------------
# > Prompt body
# ----------------------------------------

# Primary prompt
zppt_prompt() {
	# An empty line before the prompt slightly helps with the rewerapping bug
	# It also helps to separate commands
	print -n "\n"

	# First line of the prompt
	print -n "$(zppt_line zppt_lp_1 zppt_rp_1)\n"

	# Second line of the prompt (only left part)
	print -n "$(zppt_lp_2)"
}

# Right prompt
# Displayed on the right-hand side of the screen
zppt_rprompt() {
	# Mask space as a 0 width character, which shifts the prompt over to the
	# right by one character and gets rid of the indentation after the prompt
	print -n "%{ %}"

	# Second line of the prompt (only right part)
	print -n "$(zppt_rp_2)"
}

# Secondary prompt
# Printed when the shell needs more information to complete a command
zppt_prompt2() {
	ZPPT_SEGMENT=zppt_segment_left

	# Content
	$ZPPT_SEGMENT 3 0
	print -n "%_"

	$ZPPT_SEGMENT
}

# Selection prompt
# Used within a select loop
zppt_prompt3() {
	ZPPT_SEGMENT=zppt_segment_left

	# Content
	$ZPPT_SEGMENT 5 0
	print -n "?#"

	$ZPPT_SEGMENT
}

# Spelling prompt
# Used for spelling correction
zppt_sprompt() {
	ZPPT_SEGMENT=zppt_segment_left

	# Content
	$ZPPT_SEGMENT 1 0
	print -n "zsh $ZPPT_L_SSEP correct '%R' to '%r' $ZPPT_L_SSEP [nyae]"

	$ZPPT_SEGMENT
}

# ----------------------------------------
# > Prompt parts
# ----------------------------------------

# First line left part
zppt_lp_1() {
	ZPPT_SEGMENT=zppt_segment_left

	# Components
	zppt_ssh
	zppt_context
	zppt_dir

	$ZPPT_SEGMENT
}

# First line right part
zppt_rp_1() {
	ZPPT_SEGMENT=zppt_segment_right

	# Components
	zppt_status
	zppt_background

	$ZPPT_SEGMENT
}

# Second line left part
zppt_lp_2() {
	ZPPT_SEGMENT=zppt_segment_left

	# Components
	zppt_privilege

	$ZPPT_SEGMENT
}

# Second line right part
zppt_rp_2() {
	ZPPT_SEGMENT=zppt_segment_right

	# Components
	zppt_time

	$ZPPT_SEGMENT
}

# ----------------------------------------
# > Prompt construction functions
# ----------------------------------------

# Get display length of an argument
zppt_length() {
	print -n $(( ${#${(S%%)1//(\%([KF1]|)\{*\}|\%[Bbkf])}} ))
}

# Construct a line consisting of left and right parts
zppt_line() {
	left="$($1)"
	right="$($2)"

	# Calculate the gap between the left and the right parts of the line
	gap=$(( $(tput cols) - $(zppt_length "$left") - $(zppt_length "$right") ))

	# Print the left part
	print -n "$left"

	# If it fits, align and print the right part
	[[ $gap -ge 0 ]] && print -n "${(l:$gap:)}$right"
}

# Left segment
# Provided with 2 arguments (background & foreground) opens a new segment
# Omitting arguments closes the open segments
zppt_segment_left() {
	[[ -n $ZPPT_PREV_BG ]] && print -n " "
	[[ -n $1 ]] && print -n "%K{$1}" || print -n "%k"
	[[ -n $ZPPT_PREV_BG ]] && print -n "%F{$ZPPT_PREV_BG}$ZPPT_L_SEP " || print -n " "
	[[ -n $2 ]] && print -n "%F{$2}" || print -n "%f"
	ZPPT_PREV_BG="$1"
}

# Right segment
# Provided with 2 arguments (background & foreground) opens a new segment
# Omitting arguments closes the open segments
zppt_segment_right() {
	[[ -n $1 ]] && print -n " %F{$1}$ZPPT_R_SEP%K{$1} " || print -n " %k"
	[[ -n $2 ]] && print -n "%F{$2}" || print -n "%f"
}

# ----------------------------------------
# > Prompt components
# ----------------------------------------

# Local hosts and remote remote (SSH) host indicator
zppt_ssh() {
	if [[ -z $SSH_CONNECTION ]]; then
		$ZPPT_SEGMENT 7 0
		# Linux Tux
		print -n "\uF17C"
	else
		$ZPPT_SEGMENT 2 0
		# Console icon (SSH)
		print -n "\uF489"
	fi
}

# Context (username@hostname)
zppt_context() {
	$ZPPT_SEGMENT 18 3
	print -n "%n@%M"
}

# Current working directory
zppt_dir() {
	$ZPPT_SEGMENT 4 0

	# Get trunctated version of working directory
	dir=$(print -P "%$ZPPT_DIR_MAX~")

	# Prepend with ~ if needed
	[[ "~/$dir" == $(print -P "%~") ]] && dir="~/$dir"

	# Prepend with ... if it was trunctated
	[[ $dir != $(print -P "%~") ]] && dir="\u2026/$dir"

	# Replace / with subsegment separators
	dir=${dir//\// $ZPPT_L_SSEP }

	print -n "$dir"
}

# Privilege status
zppt_privilege() {
	$ZPPT_SEGMENT 4 0
	print -n "%(!.#.$)"
}

# Return status of last command
zppt_status() {
	if [[ $RETVAL -ne 0 ]]; then
		# Fail status
		$ZPPT_SEGMENT 1 0
		print -n "\uF00D"
	else
		# Success status
		# $ZPPT_SEGMENT 2 0
		# print -n "\uF00C"
	fi
}

# Background jobs
zppt_background() {
	# Get amount of jobs in the background
	JOBS=$(jobs -l | wc -l)

	if [[ $JOBS -gt 0 ]]; then
		# Do not print the number if only one background job 
		[[ $JOBS -eq 1 ]] && JOBS="" || JOBS+=" "

		$ZPPT_SEGMENT 4 0
		print -n "$JOBS\uF013"
	fi
}

# Time
zppt_time() {
	$ZPPT_SEGMENT 7 0
	print -n "%D{%H:%M:%S} \uF017"
}
