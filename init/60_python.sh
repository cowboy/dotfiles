# Initialize pyenv.
source $DOTFILES/source/58_python.sh

# Install Python.
if [[ "$(type -P pyenv)" ]]; then
  versions=(2.7.10)

  pythons=($(setdiff "${versions[*]}" "$(pyenv whence python)"))
  if (( ${#pythons[@]} > 0 )); then
    e_header "Installing Python versions: ${pythons[*]}"
    for r in "${pythons[@]}"; do
      pyenv install "$r"
      [[ "$r" == "${versions[0]}" ]] && pyenv global "$r"
    done
  fi
fi
