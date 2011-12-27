# Ubuntu-only stuff. Abort if not Ubuntu.
[[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1

# Update apt
e_header "Updating apt"
sudo apt-get update
sudo apt-get upgrade

# Install tools and programs.
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
  e_header "Installing packages: ${list[*]}"
  for package in "${list[@]}"; do
    sudo apt-get -qq install "$package"
  done
fi
