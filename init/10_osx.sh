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
  fi

  # htop
  if [[ "$(type -P htop)" && "$(stat -L -f "%Su:%Sg" "$(which htop)")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$(which htop)") & 4))" ]]; then
    e_header "Updating htop permissions"
    sudo chown root:wheel "$(which htop)"
    sudo chmod u+s "$(which htop)"
  fi

  # bash
  if [[ "$(which bash)" != "/bin/bash" && "$(cat /etc/shells | grep -q "$(which bash)")" ]]; then
    e_header "Adding $(which bash) to the list of acceptable shells"
    which bash | sudo tee -a /etc/shells >/dev/null
  fi
  if [[ "$(which bash)" != "/bin/bash" && "$(which bash)" != "$SHELL" ]]; then
    e_header "Making $(which bash) the default shell, you should restart your shell(s)"
    sudo chsh -s "$(which bash)" "$USER"
  fi

  # i don't remember why i needed this?!
  if [[ ! "$(type -P gcc-4.2)" ]]; then
    e_header "Installing Homebrew dupe recipe: apple-gcc42"
    brew install https://raw.github.com/Homebrew/homebrew-dupes/master/apple-gcc42.rb
  fi
fi
