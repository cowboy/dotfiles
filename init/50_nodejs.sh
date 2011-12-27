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
