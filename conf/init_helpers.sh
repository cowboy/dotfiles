# Given a list of desired items and installed items, return a list
# of uninstalled items. Arrays in bash are insane (not in a good way).
# From http://stackoverflow.com/a/1617326/142339
function to_install() {
  local debug oldifs desired installed remain
  if [[ "$1" == 1 ]]; then debug=1; shift; fi
  # Convert args to arrays.
  desired=($1)
  installed=($2)
  oldifs="$IFS"
  IFS=$'\n'
  # Get the difference.
  if [[ ${#installed[*]} == 0 ]]; then
    remain=("${desired[*]}")
  else
    remain=($(grep -Fxv "${installed[*]}"$'\n' <<< "${desired[*]}"))
  fi
  IFS="$oldifs"
  [[ "$debug$dotfiles_debug" ]] && for v in desired installed remain; do
    echo "$v ($(eval echo "\${#$v[*]}")) $(eval echo "\${$v[*]}")" 1>&2
  done
  echo "${remain[@]}"
}

# Tap Homebrew kegs.
function brew_tap_kegs() {
  kegs=($(to_install "${kegs[*]}" "$(brew tap)"))
  if [[ ${#kegs[@]} != 0 ]]; then
    e_header "Tapping Homebrew kegs: ${kegs[@]}"
    for keg in "${kegs[@]}"; do
      brew tap $keg
    done
  fi
}

# Install Homebrew recipes.
function brew_install_recipes() {
  recipes=($(to_install "${recipes[*]}" "$(brew list)"))
  if [[ ${#recipes[@]} != 0 ]]; then
    e_header "Installing Homebrew recipes: ${recipes[@]}"
    for recipe in "${recipes[@]}"; do
      brew install $recipe
    done
  fi
}
