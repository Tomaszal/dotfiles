# ----------------------------------------
# > Environment variables
# ----------------------------------------

# Prevent duplicate entries in PATH
declare -U PATH

# Word characters (apart from alphanumeric)
# Excluded: . , :  ' " / | \ < > @ +
export WORDCHARS='*?_[]~=&;!#$%^(){}'

# Default editor (VSCode)
export EDITOR=code

# Default pager and options (less)
export PAGER=less
export LESS="-i -R"
export LESSHISTFILE="/dev/null"
