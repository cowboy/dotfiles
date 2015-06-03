# Initialize rbenv.
source $DOTFILES/source/56_ruby.sh

# Install Ruby.
if [[ "$(type -P rbenv)" ]]; then
  versions=(2.2.2)

  rubies=($(setdiff "${versions[*]}" "$(rbenv whence ruby)"))
  if (( ${#rubies[@]} > 0 )); then
    e_header "Installing Ruby versions: ${rubies[*]}"
    for r in "${rubies[@]}"; do
      rbenv install "$r"
      [[ "$r" == "${versions[0]}" ]] && rbenv global "$r"
    done
  fi
fi
