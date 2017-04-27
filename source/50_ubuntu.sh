# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

# Make 'less' more.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

