# Exit if Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Brew casks need Homebrew to install." && return 1

# Ensure the cask keg and recipe are installed.
kegs=(caskroom/cask)
brew_tap_kegs
recipes=(brew-cask)
brew_install_recipes

# Exit if, for some reason, cask is not installed.
[[ ! "$(brew ls --versions brew-cask)" ]] && e_error "Brew-cask failed to install." && return 1

# Hack to show the first-run brew-cask password prompt immediately.
brew cask info this-is-somewhat-annoying 2>/dev/null

# Homebrew casks
casks=(
  a-better-finder-rename
  bettertouchtool
  betterzipql
  charles
  chromium
  chronosync
  colorpicker-developer
  colorpicker-skalacolor
  crashlytics
  dropbox
  fastscripts
  firefox
  google-chrome
  gyazo
  handbrake
  hex-fiend
  hockeyapp
  imageoptim
  istat-menus
  iterm2
  kaleidoscope
  launchrocket
  licecap
  macvim
  mou
  mplayer
  omnidisksweeper
  opera-next
  qlcolorcode
  qlmarkdown
  qlprettypatch
  qlstephen
  quicklook-csv
  quicklook-json
  quicknfo
  race-for-the-galaxy
  reaper
  reveal
  sequel-pro
  sonos
  sourcetree
  spotify
  sublime-text
  suspicious-package
  thunder
  tower
  transmission
  transmission-remote-gui
  vagrant
  vagrant-manager
  virtualbox
  vlc
  webp-quicklook
)

# Install Homebrew casks.
casks=($(setdiff "${casks[*]}" "$(brew cask list 2>/dev/null)"))
if (( ${#casks[@]} > 0 )); then
  e_header "Installing Homebrew casks: ${casks[*]}"
  for cask in "${casks[@]}"; do
    brew cask install $cask
  done
  brew cask cleanup
fi

# Work around colorPicker symlink issue.
# https://github.com/caskroom/homebrew-cask/issues/7004
cps=()
for f in ~/Library/ColorPickers/*.colorPicker; do
  [[ -L "$f" ]] && cps=("${cps[@]}" "$f")
done

if (( ${#cps[@]} > 0 )); then
  e_header "Fixing colorPicker symlinks"
  for f in "${cps[@]}"; do
    target="$(readlink "$f")"
    e_arrow "$(basename "$f")"
    rm "$f"
    cp -R "$target" ~/Library/ColorPickers/
  done
fi
