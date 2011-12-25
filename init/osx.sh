# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# Install Homebrew.
if [[ ! "$(type -P brew)" ]]; then
  e_header "Installing Homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.github.com/gist/323731)"
  brew update
fi

# Install Homebrew recipes.
if [[ "$(type -P brew)" ]]; then
  recipes=(git node rbenv ruby-build tree sl lesspipe)

  list="$(to_install "${recipes[*]}" "$(brew list)")"
  if [[ "$list" ]]; then
    e_header "Installing Homebrew recipes: $list"
    brew install $list
  fi

  # Newer OSX XCode comes with an LLVM gcc which rbenv can't use.
  if [[ ! "$(type -P gcc)" || ! "$(brew list | grep -w "gcc")" ]]; then
    e_header "Installing Homebrew-alt gcc recipe"
    echo "Note: this step can take ~20 minutes, but is required by rbenv install."
    skip || brew install https://github.com/adamv/homebrew-alt/raw/master/duplicates/gcc.rb
  fi
fi

# Install Ruby.
if [[ "$(type -P rbenv)" ]]; then
  versions=(1.9.2-p290 1.8.7-p352)

  list="$(to_install "${versions[*]}" "$(rbenv versions | sed 's/^[* ]*//;s/ .*//')")"
  if [[ "$list" ]]; then
    e_header "Installing Ruby versions: $list"
    type -t _rbenv > /dev/null || eval "$(rbenv init -)"
    # Hopefully this will get "fixed" soon.
    # https://github.com/sstephenson/ruby-build/issues/109
    # Also see source/osx.sh
    [[ "$CC" ]] || export CC="$(
      shopt -s nullglob
      gccs=(/usr/local/bin/gcc-*)
      echo "${gccs[0]}"
    )"
    for version in $list; do rbenv install "$version"; done
    [[ "$(echo "$list" | grep -w "${versions[0]}")" ]] && rbenv global "${versions[0]}"
    rbenv rehash
  fi
fi

# Install Npm (for some reason, the brew recipe doesn't do this).
if [[ "$(type -P node)" && ! "$(type -P npm)" ]]; then
  e_header "Installing Npm"
  curl http://npmjs.org/install.sh | sh
fi

# Install Npm modules.
if [[ "$(type -P npm)" ]]; then
  modules=(nave jshint uglify-js)

  { pushd "$(npm config get prefix)/lib/node_modules"; installed=(*); popd; } > /dev/null
  list="$(to_install "${modules[*]}" "${installed[*]}")"
  if [[ "$list" ]]; then
    e_header "Installing Npm modules: $list"
    npm install -g $list
  fi
fi
