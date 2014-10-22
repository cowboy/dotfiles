# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# Opt-out of installing Homebrew.
[[ "$no_brew" ]] && return 1

# Homebrew kegs
kegs=()

# Homebrew recipes
recipes=(
  bash
  cowsay
  git
  git-extras
  htop-osx
  hub
  id3tool
  lesspipe
  man2html
  mercurial
  nmap
  sl
  ssh-copy-id
  the_silver_searcher
  tree
)

# Opt-out of installing Homebrew recipes.
[[ "$no_brew_recipes" ]] && recipes=()

# Homebrew casks
casks=(
  a-better-finder-rename
  bettertouchtool
  charles
  chromium
  chronosync
  dropbox
  fastscripts
  firefox
  google-chrome
  gyazo
  hex-fiend
  iterm2
  launchbar
  macvim
  moom
  reaper
  remote-desktop-connection
  rftg
  sonos
  spotify
  steam
  synology-assistant
  teamspeak-client
  the-unarchiver
  todoist
  totalfinder
  tower
  transmission-remote-gui
  vlc
  whatsize
)

# Opt-out of installing Homebrew casks.
if [[ "$no_brew_casks" ]]; then
  casks=()
else
  kegs=("${kegs[@]}" caskroom/cask)
  recipes=("${recipes[@]}" brew-cask)
fi

# Install Homebrew.
if [[ ! "$(type -P brew)" ]]; then
  e_header "Installing Homebrew"
  true | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Exit if, for some reason, Homebrew is not installed.
[[ "$(type -P brew)" ]] || return 1

e_header "Updating Homebrew"
brew doctor
brew update

# Tap Homebrew kegs.
kegs=($(to_install "${kegs[*]}" "$(brew tap)"))
if [[ ${#kegs[@]} != 0 ]]; then
  e_header "Tapping Homebrew kegs: ${kegs[@]}"
  for keg in "${kegs[@]}"; do
    brew tap $keg
  done
fi

# Install Homebrew recipes.
recipes=($(to_install "${recipes[*]}" "$(brew list)"))
if [[ ${#recipes[@]} != 0 ]]; then
  e_header "Installing Homebrew recipes: ${recipes[@]}"
  for recipe in "${recipes[@]}"; do
    brew install $recipe
  done
fi

# Install Homebrew casks.
if [[ "$(brew ls --versions brew-cask)" ]]; then
  casks=($(to_install "${casks[*]}" "$(brew cask list 2>/dev/null)"))
  if [[ ${#casks[@]} != 0 ]]; then
    e_header "Installing Homebrew casks: ${casks[@]}"
    for cask in "${casks[@]}"; do
      brew cask install $cask
    done
    brew cask cleanup
  fi
fi

# Fix or further initialize Homebrew-installed items.

# This is where brew stores its binary symlinks
local binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin

# htop
if [[ "$(type -P $binroot/htop)" && "$(stat -L -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$binroot/htop") & 4))" ]]; then
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
