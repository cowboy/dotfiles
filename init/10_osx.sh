# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# Some tools look for XCode, even though they don't need it.
# https://github.com/joyent/node/issues/3681
# https://github.com/mxcl/homebrew/issues/10245
if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
  sudo xcode-select -switch /usr/bin
fi

# Install Homebrew.
if [[ ! "$(type -P brew)" ]]; then
  e_header "Installing Homebrew"
  true | ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
fi

if [[ "$(type -P brew)" ]]; then
  e_header "Updating Homebrew"
  brew doctor
  brew update

  # Install Homebrew recipes.
  recipes=(
    bash
    ssh-copy-id
    git git-extras hub
    tree sl id3tool cowsay
    lesspipe nmap
    htop-osx man2html
  )

  list="$(to_install "${recipes[*]}" "$(brew list)")"
  if [[ "$list" ]]; then
    e_header "Installing Homebrew recipes: $list"
    brew install $list

    if [[ ! "$(to_install "bash" "$list")" && ! "$(to_install "bash" "$(brew list)")" ]]; then
      e_header "Adding bash to /etc/shells (requires sudo)"
      which bash | sudo tee -a /etc/shells >/dev/null
    fi

    if [[ ! "$(to_install "htop-osx" "$list")" && ! "$(to_install "htop-osx" "$(brew list)")" ]]; then
      e_header "Updating htop permissions (requires sudo)"
      sudo chown root:wheel "$(which htop)"
      sudo chmod u+s "$(which htop)"
    fi
  fi

  if [[ ! "$(type -P gcc-4.2)" ]]; then
    e_header "Installing Homebrew dupe recipe: apple-gcc42"
    brew install https://raw.github.com/Homebrew/homebrew-dupes/master/apple-gcc42.rb
  fi
fi
