# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew recipes need Homebrew to install." && return 1

# Homebrew recipes
recipes=(
  caskroom/cask/brew-cask
  ack
  atool
  autojump
  axel
  bash
  bash-completion
  bup
  clib
  coreutils
  cowsay
  ctags
  curl
  czmq
  exiftool
  ffmpeg
  findutils
  flow
  fontconfig
  fontforge
  git
  git-extras
  htop-osx
  hub
  id3tool
  imagemagick
  legit
  lesspipe
  libsodium
  libxml2
  lynx
  mackup
  man2html
  mercurial
  moreutils
  mosh
  nmap
  openssl
  phantomjs
  pyenv
  pyenv-virtualenv
  python
  qrencode
  ranger
  rbenv
  rename
  renameutils
  ruby-build
  sqlite
  ssh-copy-id
  swiftlint
  tesseract
  the_silver_searcher
  tig
  tmux
  tree
  vim
  w3m
  watchman
  weighttp
  wget
  zeromq
  zsh
)

brew_install_recipes

# Misc cleanup!

# This is where brew stores its binary symlinks
local binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin

# htop
if [[ "$(type -P $binroot/htop)" ]] && [[ "$(stat -L -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$binroot/htop") & 4))" ]]; then
  e_header "Updating htop permissions"
  sudo chown root:wheel "$binroot/htop"
  sudo chmod u+s "$binroot/htop"
fi

# bash
if [[ "$(type -P $binroot/bash)" && "$(cat /etc/shells | grep -q "$binroot/bash")" ]]; then
  e_header "Adding $binroot/bash to the list of acceptable shells"
  echo "$binroot/bash" | sudo tee -a /etc/shells >/dev/null
fi
if [[ "$(dscl . -read ~ UserShell | awk '{print $2}')" != "$binroot/bash" ]]; then
  e_header "Making $binroot/bash your default shell"
  sudo chsh -s "$binroot/bash" "$USER" >/dev/null 2>&1
  e_arrow "Please exit and restart all your shells."
fi
