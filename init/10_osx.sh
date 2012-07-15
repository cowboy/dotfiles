# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# XCode and the Command Line Tools really need to be installed first.
if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
  echo "XCode and the Command Line Tools must be installed first."
  exit 1
fi

# Install Homebrew.
if [[ ! "$(type -P brew)" ]]; then
  e_header "Installing Homebrew"
  true | /usr/bin/ruby -e "$(/usr/bin/curl -fsSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"
fi

if [[ "$(type -P brew)" ]]; then
  e_header "Updating Homebrew"
  brew update

  # Install Homebrew recipes.
  recipes=(git tree sl lesspipe id3tool nmap git-extras htop-osx man2html)

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
