# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# Install Homebrew.
if [[ ! "$(type -p brew)" ]]; then
  e_header "Installing Homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"
  brew update
fi

# Install Homebrew recipes.
if [[ "$(type -p brew)" ]]; then
  recipes="git node rbenv tree sl lesspipe"

  recipes="$(to_install "$recipes" "$(brew list)")"
  if [[ "$recipes" ]]; then
    e_header "Installing Homebrew recipes: $recipes"
    brew install $recipes
  fi
fi

# Install Npm (for some reason, the brew recipe doesn't do this).
if [[ "$(type -p node)" && ! "$(type -p npm)" ]]; then
  e_header "Installing Npm"
  curl http://npmjs.org/install.sh | sh
fi

# Install Npm modules.
if [[ "$(type -p npm)" ]]; then
  modules="nave jshint uglify-js"

  cd "$(npm config get prefix)/lib/node_modules"; installed=(*); cd - > /dev/null
  modules="$(to_install "$modules" "${installed[*]}")"
  if [[ "$modules" ]]; then
    e_header "Installing Npm modules: $modules"
    npm install -g $modules
  fi
fi
