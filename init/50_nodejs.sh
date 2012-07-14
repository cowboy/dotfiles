# Install most recent stable Node.js with nave
node_stable="$(~/.dotfiles/bin/nave stable)"
e_header "Installing Node.js $node_stable"
~/.dotfiles/bin/nave install $node_stable >/dev/null 2>&1

# Alias the stable version of node to "default" and install Npm modules.
~/.dotfiles/bin/nave use default $node_stable (

  # Install Npm modules.
  if [[ "$(type -P npm)" ]]; then
    # Update Npm!
    npm update -g npm

    modules=(grunt jshint uglify-js codestream)

    { pushd "$(npm config get prefix)/lib/node_modules"; installed=(*); popd; } > /dev/null
    list="$(to_install "${modules[*]}" "${installed[*]}")"
    if [[ "$list" ]]; then
      e_header "Installing Npm modules: $list"
      npm install -g $list
    fi
  fi

)
