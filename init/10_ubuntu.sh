# Ubuntu-only stuff. Abort if not Ubuntu.
[[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1

# Installing this sudoers file makes life easier.
sudoers_file="sudoers-cowboy"
sudoers_dest="/etc/sudoers.d/$sudoers_file"
if [[ ! -e "$sudoers_dest" || "$sudoers_dest" -ot "conf/$sudoers_file" ]]; then
  e_header "Updating sudoers"
  {
    sudo cp "conf/$sudoers_file" "$sudoers_dest" &&
    sudo chmod 0440 "$sudoers_dest"
  } >/dev/null 2>&1
fi

# Update APT.
e_header "Updating APT"
sudo apt-get -qq update
sudo apt-get -qq upgrade

# Install APT packages.
packages=(
  build-essential libssl-dev
  git-core
  tree sl id3tool
  nmap
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
