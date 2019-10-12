# ----------------------------------------
# > Command completion
# ----------------------------------------

# Additional completion definitions for Zsh
fpath=(/usr/share/zsh/site-functions $fpath)

# Completion dump location
local ZSH_COMPDUMP="$ZSH_CACHE/compdump-${HOST/.*/}-${ZSH_VERSION}"

# Initialize completion
autoload -Uz compinit
compinit -i -d "$ZSH_COMPDUMP"
zstyle ':completion:*' use-cache on
zstyle ':completion::complete:*' cache-path "$ZSH_CACHE"

# Enable correction
setopt CORRECT

# Complete aliases
setopt COMPLETE_ALIASES

# Cycle through menus horizontally
setopt LIST_ROWS_FIRST

# ----------------------------------------
# > Completion configuration
# ----------------------------------------

# Enable approximate completions
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*:approximate:*' max-errors 2 numeric

# Automatically update PATH entries
zstyle ':completion:*' rehash true

# Use menu completion
zstyle ':completion:*' menu select

# Verbose completion results
zstyle ':completion:*' verbose true

# Group results by category
zstyle ':completion:*' group-name ''

# Keep directories and files separated
zstyle ':completion:*' list-dirs-first true

# Don't try parent path completion if the directories exist
zstyle ':completion:*' accept-exact-dirs true

# Always use menu selection for cd
zstyle ':completion:*:*:cd:*:directory-stack' force-list always
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

# Show message while waiting for completion
zstyle ':completion:*' show-completer true

# ----------------------------------------
# > Completion format
# ----------------------------------------

# Process
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,args -w -w"

# Pagination
zstyle ':completion:*' list-prompt   '%SAt %p: Hit TAB for more, or the character to insert.%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p.%s'

# Completion
zstyle ':completion:*'              format '%F{04}-> %B%d%b%f'
zstyle ':completion:*:descriptions' format '%F{01}-> %B%d%b%f'
zstyle ':completion:*:corrections'  format '%F{02}-> %B%d%b %F{03}(errors: %e)%f'
zstyle ':completion:*:warnings'     format '%F{01}-> %BNo matches for:%b %F{11}%d.%f'

# ----------------------------------------
# > Completion colors
# ----------------------------------------

# Process
zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# Path
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"

# Host & user
zstyle ':completion:*:*:*:*:hosts' list-colors '=*=30;41'
zstyle ':completion:*:*:*:*:users' list-colors '=*=$color[green]=$color[red]'
