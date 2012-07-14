source ~/.dotfiles/source/50_rbenv.sh

# Install Ruby.
if [[ "$(type -P rbenv)" ]]; then
  versions=(1.9.3-p194 1.9.2-p290 1.8.7-p352)

  list="$(to_install "${versions[*]}" "$(rbenv versions | sed 's/^[* ]*//;s/ .*//')")"
  if [[ "$list" ]]; then
    e_header "Installing Ruby versions: $list"
    for version in $list; do rbenv install "$version"; done
    [[ "$(echo "$list" | grep -w "${versions[0]}")" ]] && rbenv global "${versions[0]}"
    rbenv rehash
  fi
fi

# Install Gems.
if [[ "$(type -P gem)" ]]; then
  gems=(bundler awesome_print interactive_editor)

  list="$(to_install "${gems[*]}" "$(gem list | awk '{print $1}')")"
  if [[ "$list" ]]; then
    e_header "Installing Ruby gems: $list"
    gem install $list
  fi
fi
