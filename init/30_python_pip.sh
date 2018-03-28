# Homebrew installs python2 pip as "pip2"
for pip_cmd in pip2 pip FAIL; do [[ "$(which $pip_cmd)" ]] && break; done

# Exit if pip is not installed.
[[ $pip_cmd == FAIL ]] && e_error "Pip needs to be installed." && return 1

# Add pip packages
pip_packages=(
  netifaces
  powerline-status
  psutil
  tmuxp
)

installed_pip_packages="$($pip_cmd list 2>/dev/null | awk '{print $1}')"
pip_packages=($(setdiff "${pip_packages[*]}" "$installed_pip_packages"))

if (( ${#pip_packages[@]} > 0 )); then
  e_header "Installing pip packages (${#pip_packages[@]})"
  for package in "${pip_packages[@]}"; do
    e_arrow "$package"
    $pip_cmd install "$package"
  done
fi
