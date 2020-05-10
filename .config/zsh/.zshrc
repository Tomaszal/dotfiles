# ----------------------------------------
# > Z shell configuration
# ----------------------------------------

# Set the LS_COLORS variable with vivid
export LS_COLORS="$(vivid generate molokai)"

# Create a cache directory if it doesn't exist
ZSH_CACHE="$ZDOTDIR/cache"
mkdir -p "$ZSH_CACHE"

# Allows comments in interactive shell
setopt INTERACTIVE_COMMENTS

# Print the exit value of programs with non-zero exit status
setopt PRINT_EXIT_VALUE

# ----------------------------------------
# > History
# ----------------------------------------

# History file location
HISTFILE="$ZSH_CACHE/history"

# History file size
SAVEHIST=100000
HISTSIZE=$SAVEHIST

# Share history between different shells
setopt SHARE_HISTORY

# Save each command’s beginning timestamp
setopt EXTENDED_HISTORY

# Do not display duplicate history entries
setopt HIST_FIND_NO_DUPS

# Remove superfluous blanks before recording entry
setopt HIST_REDUCE_BLANKS

# Remove 'history' command from the history
setopt HIST_NO_STORE

# ----------------------------------------
# > Imports
# ----------------------------------------

# Powerlevel9k prompt theme
POWERLEVEL9K_MODE='awesome-fontconfig'
source "/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme"
source "$ZDOTDIR/prompt.zsh"

# Aliases
source "$ZDOTDIR/alias.zsh"

# Command completion
source "$ZDOTDIR/completion.zsh"

# Autosuggestions plugin
source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Syntax highlighting plugin
source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# History substring search plugin
source "/usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"

# Key bindings
source "$ZDOTDIR/keymap.zsh"
