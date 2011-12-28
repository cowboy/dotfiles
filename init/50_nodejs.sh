# If not on OS X, install Node. Hopefully, someday, there will be a more
# current Node PPA for Ubuntu.
if [[ ! "$OSTYPE" =~ ^darwin ]]; then
  # From https://github.com/isaacs/nave/blob/master/nave.sh
  node_stable="$(
    curl -sL "http://nodejs.org/dist/" \
      | egrep -o '[0-9]+\.[2468]\.[0-9]+' \
      | sort -u -k 1,1n -k 2,2n -k 3,3n -t . \
      | tail -n1
  )"

  if [[ ! "$(type -P node)" || "$(node --version)" != "v$node_stable" ]]; then
    e_header "Installing Node v$node_stable"
    node_url="http://nodejs.org/dist/v$node_stable/node-v$node_stable.tar.gz"
    (
      sudo mkdir -p "/usr/local/src" &&
      cd "/usr/local/src" &&
      sudo curl --progress-bar "$node_url" -o "node-v$node_stable.tar.gz" &&
      sudo tar -xzf "node-v$node_stable.tar.gz" &&
      cd "node-v$node_stable" &&
      echo "Configuring" &&
      sudo ./configure >/dev/null 2>&1 &&
      echo "Building" &&
      sudo make >/dev/null 2>&1 &&
      echo "Installing" &&
      sudo make install >/dev/null 2>&1  &&
      # Update Npm!
      echo "Updating Npm" &&
      sudo npm update -g npm
    ) 
  fi
fi

# Install Npm if necessary (the brew recipe doesn't do this).
if [[ "$(type -P node)" && ! "$(type -P npm)" ]]; then
  e_header "Installing Npm"
  curl http://npmjs.org/install.sh | sh
  # Update Npm!
  npm update -g npm
fi

# Install Npm modules.
if [[ "$(type -P npm)" ]]; then
  modules=(jshint uglify-js)

  { pushd "$(npm config get prefix)/lib/node_modules"; installed=(*); popd; } > /dev/null
  list="$(to_install "${modules[*]}" "${installed[*]}")"
  if [[ "$list" ]]; then
    e_header "Installing Npm modules: $list"
    if [[ "$(type -P brew)" ]]; then
      npm install -g $list
    else
      sudo npm install -g $list
    fi
  fi
fi
