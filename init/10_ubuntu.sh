# Ubuntu-only stuff. Abort if not Ubuntu.
[[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1

# If the old files isn't removed, the duplicate APT alias will break sudo!
sudoers_old="/etc/sudoers.d/sudoers-cowboy"; [[ -e "$sudoers_old" ]] && sudo rm "$sudoers_old"

# Installing this sudoers file makes life easier.
sudoers_file="sudoers-dotfiles"
sudoers_src=~/.dotfiles/conf/ubuntu/$sudoers_file
sudoers_dest="/etc/sudoers.d/$sudoers_file"
if [[ ! -e "$sudoers_dest" || "$sudoers_dest" -ot "$sudoers_src" ]]; then
  e_header "Updating sudoers"
  visudo -cf "$sudoers_src" >/dev/null && {
    sudo cp "$sudoers_src" "$sudoers_dest" &&
    sudo chmod 0440 "$sudoers_dest"
  } >/dev/null 2>&1 &&
  echo "File $sudoers_dest updated."
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
  nmap telnet
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
