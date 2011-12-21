# Linux-only stuff. Abort if not linux.
if [[ ! "$OSTYPE" =~ ^linux ]]; then
  return
fi

# ubuntu package management
alias update="sudo aptitude update"
alias install="sudo aptitude install"
alias upgrade="sudo aptitude safe-upgrade"
alias remove="sudo aptitude remove"
alias search="aptitude search"
