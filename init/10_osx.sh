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
  ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
fi

if [[ "$(type -P brew)" ]]; then
  e_header "Updating Homebrew"
  brew doctor
  brew update

  # Install Homebrew recipes.
  recipes=(git tree sl lesspipe id3tool nmap git-extras htop-osx man2html hub cowsay)

  list="$(to_install "${recipes[*]}" "$(brew list)")"
  if [[ "$list" ]]; then
    e_header "Installing Homebrew recipes: $list"
    brew install $list
  fi

  if [[ ! "$(type -P gcc-4.2)" ]]; then
    e_header "Installing Homebrew dupe recipe: apple-gcc42"
    brew install https://raw.github.com/Homebrew/homebrew-dupes/master/apple-gcc42.rb
  fi
fi
