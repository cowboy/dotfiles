# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" == darwin* ]] || return 1

# Quick look
alias ql="qlmanage -p "$@" >& /dev/null"
