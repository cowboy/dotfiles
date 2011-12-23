# Ubuntu-only stuff. Abort if not Ubuntu.
[[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1

# ubuntu package management
alias update="sudo apt-get update"
alias install="sudo apt-get install"
alias upgrade="sudo apt-get upgrade"
alias remove="sudo apt-get remove"
alias search="apt-cache search"


# /===== FROM UBUNTU DEFAULT BASHRC =====\

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# \===== FROM UBUNTU DEFAULT BASHRC =====/
