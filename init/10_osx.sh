# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# Some tools look for XCode, even though they don't need it.
# https://github.com/joyent/node/issues/3681
# https://github.com/mxcl/homebrew/issues/10245
if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
  sudo xcode-select -switch /usr/bin
fi

# Opt-out of installing Homebrew.
if [[ ! "$no_brew" ]]; then

# Install Homebrew.
if [[ ! "$(type -P brew)" ]]; then
  e_header "Installing Homebrew"
  true | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if [[ "$(type -P brew)" ]]; then
  e_header "Updating Homebrew"
  brew doctor
  brew update

  # Tap Homebrew kegs.
  kegs=(
    homebrew/dupes
    homebrew/games
    caskroom/cask
  )
  kegs=($(to_install "${kegs[*]}" "$(brew tap)"))
  if [[ ${#kegs[@]} != 0 ]]; then
    e_header "Tapping Homebrew kegs: $kegs"
    for keg in "${kegs[@]}"; do
      brew tap $keg
    done
  fi

  # Install Homebrew recipes.
  recipes=(
    bash
    ssh-copy-id
    git
    git-extras
    hub
    the_silver_searcher
    mercurial
    tree
    sl
    id3tool
    cowsay
    lesspipe
    nmap
    htop-osx
    man2html
    brew-cask
  )
  recipes=($(to_install "${recipes[*]}" "$(brew list)"))
  if [[ ${#recipes[@]} != 0 ]]; then
    e_header "Installing Homebrew recipes: $recipes"
    for recipe in "${recipes[@]}"; do
      brew install $recipe
    done
  fi

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
  if [[ "$SHELL" != "$binroot/bash" ]]; then
    e_header "Making $binroot/bash your default shell"
    sudo chsh -s "$binroot/bash" "$USER" >/dev/null 2>&1
    e_arrow "Please exit and restart all your shells."
  fi

  # Opt-out of installing Homebrew casks.
  if [[ ! "$no_brew_casks" ]]; then

  # Install Homebrew casks.
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
  casks=($(to_install "${casks[*]}" "$(brew cask list)"))
  if [[ ${#casks[@]} != 0 ]]; then
    e_header "Installing Homebrew casks: $casks"
    for cask in "${casks[@]}"; do
      brew cask install $cask
    done
  fi

  fi ### BREW CASKS OPT-OUT
fi

fi ### BREW OPT-OUT

# Copy fonts
fonts=()
for f in ~/.dotfiles/conf/osx/fonts/*; do
  [[ -e "$HOME/Library/Fonts/$(basename "$f")" ]] || fonts=("${fonts[@]}" "$f")
done

if [[ ${#fonts[@]} != 0 ]]; then
  e_header "Copying fonts (${#fonts[@]})"
  for f in "${fonts[@]}"; do
    cp "$f" "$HOME/Library/Fonts/"
  done
fi
