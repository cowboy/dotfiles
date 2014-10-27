# Initialize rbenv.
source $DOTFILES/source/50_ruby.sh

# Install Ruby.
if [[ "$(type -P rbenv)" ]]; then
  versions=(2.1.3) # 2.0.0-p576 1.9.3-p547)

  rubies=($(setdiff "${versions[*]}" "$(rbenv whence ruby)"))
  if (( ${#rubies[@]} > 0 )); then
    e_header "Installing Ruby versions: ${rubies[*]}"
    for r in "${rubies[@]}"; do
      rbenv install "$r"
      [[ "$r" == "${versions[0]}" ]] && rbenv global "$r"
    done
  fi
fi
