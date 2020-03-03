# ----------------------------------------
# > Key bindings for Zsh
# ----------------------------------------

# Disable multi-key sequences
KEYTIMEOUT=0

# Disable flow control (regain Ctrl+S/Q)
unsetopt FLOW_CONTROL

# Clear all keymaps and create a new custom one
bindkey -d
bindkey -N tomaszal
bindkey -A tomaszal main

# ----------------------------------------
# > Basic keys
# ----------------------------------------

# Alphanumeric
bindkey -R "!"-"~" self-insert
bindkey -R "\M-^@"-"\M-^?" self-insert

# Space
bindkey " " magic-space

# Return
bindkey "^M" accept-line

# Tab
bindkey "^I" expand-or-complete

# ----------------------------------------
# > Navigation
# ----------------------------------------

# Left/Right
bindkey "^[[D" backward-char
bindkey "^[[C" forward-char

# Ctrl + Left/Right
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

bindkey "^[[5D" backward-word
bindkey "^[[5C" forward-word

# Home/End
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line

# ----------------------------------------
# > Modification
# ----------------------------------------

# Delete/Backspace
bindkey "^[[3~" delete-char
bindkey '^?' backward-delete-char

# Ctrl + Delete/Backspace
bindkey '^[[3;5~' kill-word
bindkey '^H' backward-kill-word

# ----------------------------------------
# > History
# ----------------------------------------

# Up/Down
bindkey "^[[A" up-line-or-history
bindkey "^[[B" down-line-or-history

# Ctrl + Up/Down (history search)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[1;5A" up-line-or-beginning-search
bindkey "^[[1;5B" down-line-or-beginning-search

# Alt + Up/Down (history substring search)
bindkey "^[[1;3A" history-substring-search-up
bindkey "^[[1;3B" history-substring-search-down

# ----------------------------------------
# > Other shortcuts
# ----------------------------------------

# Ctrl+Z/Y
bindkey "^Z" undo
bindkey "^Y" redo

# Ctrl+K (delete line)
bindkey "^K" kill-whole-line

# Ctrl+V (literal character)
bindkey "^V" quoted-insert

# ----------------------------------------
# > Special sequences
# ----------------------------------------

# Bracketed paste
autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
bindkey "^[[200~" bracketed-paste
