# Ubuntu-only stuff. Abort if not Ubuntu.
[[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1

alias distro="lsb_release -a"

# Make 'less' more.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export VAGRANT_HOME=/vms/.vagrant.d
# export VAGRANT_DEFAULT_PROVIDER=vmware_fusion
# alias puppet="puppet --confdir /vms/.puppet"