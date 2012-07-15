export PATH

# nave init.
if [[ "$(type -P nave)" ]]; then
  nave_default="$(nave ls | awk '/^default/ {print $2}')"
  if [[ "$nave_default" && "$(node --version 2>/dev/null)" != "v$nave_default" ]]; then
    node_path=~/.nave/installed/$nave_default/bin
    if [[ -d "$node_path" ]]; then
      PATH=$node_path:$PATH
    fi
  fi
fi

npm_globals=(grunt jshint uglify-js codestream)

# Fetch and build the latest stable Node.js, assigning it the alias "default"
alias nave_stable='nave use default stable nave_init $(node --version 2>/dev/null); src'
function nave_init() {
  npm update -g npm
  if [[ "$1" != "$(node --version 2>/dev/null)" ]]; then
    npm install -g ${npm_globals[*]}
  fi
}

# rbenv init.
if [[ "$(type -P rbenv)" && ! "$(type -t _rbenv)" ]]; then
  eval "$(rbenv init -)"
  PATH=$PATH:~/.dotfiles/libs/rbenv/bin:~/.dotfiles/libs/ruby-build/bin
fi
