# ----------------------------------------
# > Interactive shell configuration
# ----------------------------------------

# Set the LS_COLORS variable
eval $(dircolors $ZDOTDIR/dircolors)

# Allows comments in interactive shell
setopt INTERACTIVE_COMMENTS

# Create a cache directory if it doesn't exist
ZSH_CACHE="$ZDOTDIR/cache"
[[ -d "$ZSH_CACHE" ]] || mkdir "$ZSH_CACHE"

# ----------------------------------------
# > History
# ----------------------------------------

# History file location
HISTFILE="$ZSH_CACHE/history"

# History file size
HISTSIZE=1000
SAVEHIST=$HISTSIZE

# Disable duplicate and unnecessary history entries
setopt HIST_IGNORE_DUPS HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS

# ----------------------------------------
# > Command completion
# ----------------------------------------

# Completion dump location
local ZSH_COMPDUMP="$ZSH_CACHE/compdump-${HOST/.*/}-${ZSH_VERSION}"

# Enable command completion
autoload -Uz compinit
compinit -i -d "$ZSH_COMPDUMP"

# General completions settings
zstyle ':completion:*' rehash true
zstyle ':completion:*' verbose true
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' accept-exact-dirs true
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*' completer _complete _approximate

# Approximate completions settings
zstyle ':completion:*:approximate:*' max-errors 2 numeric

# Cd completions settings
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Kill completions settings
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*:jobs' verbose false

# Enable correction
setopt CORRECT

# Complete aliases
setopt COMPLETE_ALIASES

# Cycle through menus horizontally
# setopt LIST_ROWS_FIRST

# ----------------------------------------
# > Load source files
# ----------------------------------------

# Aliases
source "$ZDOTDIR/alias.zsh"

# Key bindings
source "$ZDOTDIR/keymap.zsh"

# Prompt theme
source "$ZDOTDIR/prompt.zsh"

# ----------------------------------------
# > Load plugins
# ----------------------------------------

# Autosuggestions
source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Syntax highlighting
source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
