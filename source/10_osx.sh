# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" == darwin* ]] || return 1

# Quick look
alias ql="qlmanage -p "$@" >& /dev/null"

# Visual Studio Code: add `code` to path if available
[ -d /Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin ] && export PATH=$PATH:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin
