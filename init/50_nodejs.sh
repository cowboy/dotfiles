# Install Node.
# From https://github.com/isaacs/nave/blob/master/nave.sh
node_stable="$(
  curl -sL "http://nodejs.org/dist/" \
    | egrep -o '[0-9]+\.[2468]\.[0-9]+' \
    | sort -u -k 1,1n -k 2,2n -k 3,3n -t . \
    | tail -n1
)"

if [[ ! "$(type -P node)" || "$(node --version)" != "v$node_stable" ]]; then
  e_header "Installing Node v$node_stable"

  if [[ "$OSTYPE" =~ ^darwin ]]; then
    # OS X is fairly easy.
    node_url="http://nodejs.org/dist/v$node_stable/node-v$node_stable.pkg"
    node_pkg="/tmp/node-v$node_stable.pkg"
    curl --progress-bar "$node_pkg" -o "$node_pkg"
    # Not sure why Node .pkg installer needs root, but it does.
    # https://github.com/joyent/node/issues/2427
    sudo installer -pkg "$node_pkg" -target /
  else
    # Linux is a litte more complicated.
    node_url="http://nodejs.org/dist/v$node_stable/node-v$node_stable.tar.gz"
    (
      sudo mkdir -p "/usr/local/src" && \
      cd "/usr/local/src" && \
      sudo curl --progress-bar "$node_url" -o "node-v$node_stable.tar.gz" && \
      sudo tar -xzf "node-v$node_stable.tar.gz" && \
      cd "node-v$node_stable" && \
      sudo ./configure && \
      sudo make && \
      sudo make install
    ) > /dev/null
  fi
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
