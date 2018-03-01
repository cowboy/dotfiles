# Load nave- and npm-related functions.
source $DOTFILES/source/50_node.sh init

[[ ! "$(type -P npm)" ]] && e_error "npm needs to be installed." && return 1

# Install latest stable Node.js, set as default, install global npm modules.
nave_install stable
