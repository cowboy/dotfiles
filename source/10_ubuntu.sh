# Ubuntu-only stuff. Abort if not Ubuntu or its derrivatives
[[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] \
    || [[ "$(cat /etc/issue 2> /dev/null)" =~ elementary ]] \
    || [[ "$(cat /etc/issue 2> /dev/null)" =~ Mint ]] \
    || return 1

# Use 256 color terminal
export TERM='xterm-256color'

alias uu='sudo apt-get update && sudo apt-get upgrade -y'
alias udu='sudo apt-get update && sudo apt-get dist-upgrade -y'
alias aa='sudo apt-get autoremove -y && sudo apt-get autoclean'
