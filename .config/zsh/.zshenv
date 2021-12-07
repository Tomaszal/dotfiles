# ----------------------------------------
# > Environment variables
# ----------------------------------------

# Prevent duplicate entries in PATH
declare -U PATH

# Word characters (apart from alphanumeric)
# Excluded: . , :  ' " / | \ < > @ +
export WORDCHARS='*?_[]~=&;!#$%^(){}'

# Default editor (VSCode)
export EDITOR="code --wait"

# Default pager and options (less)
export PAGER=less
export LESS="-i -R"
export LESSHISTFILE="/dev/null"

# Ruby path
export PATH=${PATH}:${HOME}/.gem/ruby/2.6.0/bin

# Android SDK
export ANDROID_SDK_ROOT="~/.android/sdk"
export PATH="$PATH:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools"
