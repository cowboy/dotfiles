# Ubuntu-only stuff. Abort if not Ubuntu.
[[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1

# Update APT.
e_header "Updating APT"
sudo apt-get -qq update
sudo apt-get -qq upgrade

# Install APT packages.
packages=(
  build-essential libssl-dev
  git-core
  tree sl
)

list=()
for package in "${packages[@]}"; do
  if [[ ! "$(dpkg -s "$package" 2> /dev/null)" ]]; then
    list=("${list[@]}" "$package")
  fi
done

if (( ${#list[@]} > 0 )); then
  e_header "Installing APT packages: ${list[*]}"
  for package in "${list[@]}"; do
    sudo apt-get -qq install "$package"
  done
fi
