# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# APPLE, Y U PUT /usr/bin B4 /usr/local/bin?!
PATH=/usr/local/bin:$(path_remove /usr/local/bin):~/bin
export PATH

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Make 'less' more.
eval "$(lesspipe.sh)"

# Start ScreenSaver. This will lock the screen if locking is enabled.
alias ss="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"

export VAGRANT_HOME=/vms/.vagrant.d
#export VAGRANT_DEFAULT_PROVIDER=vmware_fusion
alias puppet="puppet --confdir /vms/.puppet"

export WORKON_HOME="$HOME/virtual_envs/"
source "/usr/local/bin/virtualenvwrapper.sh"
export SECURITY_MONKEY_SETTINGS="$HOME/security_monkey/env-config/config-local.py"