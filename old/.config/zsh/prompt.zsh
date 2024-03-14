# ----------------------------------------
# > Awesome terminal font mappings
# ----------------------------------------

source "/usr/share/fonts/awesome-terminal-fonts/devicons-regular.sh"
source "/usr/share/fonts/awesome-terminal-fonts/fontawesome-regular.sh"
source "/usr/share/fonts/awesome-terminal-fonts/octicons-regular.sh"
source "/usr/share/fonts/awesome-terminal-fonts/pomicons-regular.sh"

# ----------------------------------------
# > Powerlevel9k settings
# ----------------------------------------

# Add empty line before each prompt
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# Two line prompt
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_RPROMPT_ON_NEWLINE=false

# Line prefixes
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="%S $ %s$(print_icon 'LEFT_SEGMENT_SEPARATOR') "

# Prompt elements
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs time)

# ----------------------------------------
# > Element settings
# ----------------------------------------

# dir
POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_DIR_PATH_SEPARATOR=" $(print_icon 'LEFT_SUBSEGMENT_SEPARATOR') "
POWERLEVEL9K_DIR_SHOW_WRITABLE=true

# status
POWERLEVEL9K_STATUS_OK=false