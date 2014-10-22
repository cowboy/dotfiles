# Opt-out of installing Node.
[[ "$no_node" ]] && return 1

# Load npm_globals, add the default node into the path.
source ~/.dotfiles/source/50_node.sh

# Install Node.js.
if [[ "$(type -P nave)" ]]; then
  nave_stable="$(nave stable)"
  if [[ "$(node --version 2>/dev/null)" != "v$nave_stable" ]]; then
    e_header "Installing Node.js $nave_stable"
    # Install most recent stable version.
    nave install stable >/dev/null 2>&1
  fi
  if [[ "$(nave ls | awk '/^default/ {print $2}')" != "$nave_stable" ]]; then
    # Alias the stable version of node as "default".
    nave use default stable true
  fi
fi

# Load npm_globals, add the default node into the path.
source ~/.dotfiles/source/50_node.sh

# Install Npm modules.
if [[ "$(type -P npm)" ]]; then
  e_header "Updating Npm"
  npm update -g npm

  { pushd "$(npm config get prefix)/lib/node_modules"; installed=(*); popd; } > /dev/null
  list="$(to_install "${npm_globals[*]}" "${installed[*]}")"
  if [[ "$list" ]]; then
    e_header "Installing Npm modules: $list"
    npm install -g $list
  fi
fi
