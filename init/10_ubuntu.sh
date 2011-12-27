# Ubuntu-only stuff. Abort if not Ubuntu.
[[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1

# Update apt
sudo apt-get -qqy update
sudo apt-get -qqy upgrade

# Install tools and programs.
packages=(
  build-essential
  git-core
  nodejs
  ruby rubygems1.8
  tree sl lesspipe
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
    sudo apt-get -qqy install "$package"
  done
fi
