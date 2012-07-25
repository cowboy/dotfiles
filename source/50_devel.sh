export PATH

# nave init.
if [[ "$(type -P nave)" ]]; then
  nave_default="$(nave ls | awk '/^default/ {print $2}')"
  if [[ "$nave_default" && "$(node --version 2>/dev/null)" != "v$nave_default" ]]; then
    node_path=~/.nave/installed/$nave_default/bin
    if [[ -d "$node_path" ]]; then
      PATH=$node_path:$(path_remove ~/.nave/installed/*/bin)
    fi
  fi
fi

npm_globals=(grunt jshint uglify-js codestream)

# Fetch and build the latest stable Node.js, assigning it the alias "default"
alias nave_stable='nave use default stable nave_stable_2 $(node --version 2>/dev/null); src'
function nave_stable_2() {
  npm update -g npm
  if [[ "$1" != "$(node --version 2>/dev/null)" ]]; then
    echo "Node.js version updated to $1, installing Npm global modules."
    npm install -g ${npm_globals[*]}
  else
    echo "Node.js version $1 unchanged."
  fi
}

# Publish module to Npm registry, but don't update "latest" unless the version
# is an actual release version!
function npm_publish() {
  local version="$(node -pe 'require("./package.json").version' 2>/dev/null)"
  if [[ "${version#v}" =~ [a-z] ]]; then
    echo "Publishing dev version $version with --tag=devel"
    npm publish --tag=devel "$@"
  else
    echo "Publishing new latest version $version"
    npm publish "$@"
  fi
}

# rbenv init.
PATH=$(path_remove ~/.dotfiles/libs/rbenv/bin):~/.dotfiles/libs/rbenv/bin
PATH=$(path_remove ~/.dotfiles/libs/ruby-build/bin):~/.dotfiles/libs/ruby-build/bin

if [[ "$(type -P rbenv)" && ! "$(type -t _rbenv)" ]]; then
  eval "$(rbenv init -)"
fi
