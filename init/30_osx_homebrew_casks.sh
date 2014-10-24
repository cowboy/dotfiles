# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# Exit if Homebrew is not installed.
[[ "$(type -P brew)" ]] || return 1

# Ensure the cask keg and recipe are installed.
kegs=(caskroom/cask)
brew_tap_kegs
recipes=(brew-cask)
brew_install_recipes

# Exit if, for some reason, cask is not installed.
[[ "$(brew ls --versions brew-cask)" ]] || return 1

# Hack to show the first-run brew-cask password prompt immediately.
brew cask info this-is-somewhat-annoying 2>/dev/null

# Homebrew casks
casks=(
  # Password required
  chronosync
  remote-desktop-connection
  totalfinder
  transmission-remote-gui
  # No password required
  a-better-finder-rename
  bettertouchtool
  charles
  chromium
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
  race-for-the-galaxy
  sonos
  spotify
  steam
  synology-assistant
  teamspeak-client
  the-unarchiver
  todoist
  tower
  vlc
  whatsize
)

# Install Homebrew casks.
casks=($(to_install "${casks[*]}" "$(brew cask list 2>/dev/null)"))
if [[ ${#casks[@]} != 0 ]]; then
  e_header "Installing Homebrew casks: ${casks[@]}"
  for cask in "${casks[@]}"; do
    brew cask install $cask
  done
  brew cask cleanup
fi
