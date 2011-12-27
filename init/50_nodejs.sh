# Install Node.
if [[ ! "$(type -P node)" ]]; then
  # From https://github.com/isaacs/nave/blob/master/nave.sh
  node_stable="$(
    curl -s http://nodejs.org/dist/ \
      | egrep -o '[0-9]+\.[2468]\.[0-9]+' \
      | sort -u -k 1,1n -k 2,2n -k 3,3n -t . \
      | tail -n1
  )"
  e_header "Installing Node v$node_stable"
  source ~/.dotfiles/libs/nvm/nvm.sh
  nvm install "v$node_stable" > /dev/null
  nvm alias default "v$node_stable"
fi

# Install Npm.
if [[ "$(type -P node)" && ! "$(type -P npm)" ]]; then
  e_header "Installing Npm"
  curl http://npmjs.org/install.sh | sh
fi

# Install Npm modules.
if [[ "$(type -P npm)" ]]; then
  modules=(jshint uglify-js)

  { pushd "$(npm config get prefix)/lib/node_modules"; installed=(*); popd; } > /dev/null
  list="$(to_install "${modules[*]}" "${installed[*]}")"
  if [[ "$list" ]]; then
    e_header "Installing Npm modules: $list"
    npm install -g $list
  fi
fi
