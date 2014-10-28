# Ubuntu-only stuff. Abort if not Ubuntu or its derrivatives
[[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] \
    || [[ "$(cat /etc/issue 2> /dev/null)" =~ elementary ]] \
    || [[ "$(cat /etc/issue 2> /dev/null)" =~ Mint ]] \
    || return 1

# Add git-core ppa, to get the latest version of git
[ -f /etc/apt/sources.list.d/git-core-ppa*.list ] \
    || sudo add-apt-repository -y ppa:git-core/ppa

# Update APT.
e_header "Updating APT"
sudo apt-get -qq update
sudo apt-get -qq dist-upgrade

# Install APT packages.
packages=(
  dnsutils
  tree
  nmap
)

list=()
for package in "${packages[@]}"; do
  if [[ ! "$(dpkg -l "$package" 2>/dev/null | grep "^ii  $package")" ]]; then
    list=("${list[@]}" "$package")
  fi
done

if (( ${#list[@]} > 0 )); then
  e_header "Installing APT packages: ${list[*]}"
  for package in "${list[@]}"; do
    sudo apt-get -qq install "$package"
  done
fi

# Install Git Extras
if [[ ! "$(type -P git-extras)" ]]; then
  e_header "Installing Git Extras"
  (
    cd ~/.dotfiles/libs/git-extras &&
    sudo make install
  )
fi

# Install node from nodesource
e_header "Installing node"
[ -f /etc/apt/sources.list.d/nodesource.list ] \
    || curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install -y nodejs
