# Opt-out of installing Ruby.
[[ "$no_ruby" ]] && return 1

# Initialize rbenv.
source ~/.dotfiles/source/50_ruby.sh

# Install Ruby.
if [[ "$(type -P rbenv)" ]]; then
  versions=(2.1.3 2.0.0-p576 1.9.3-p547)

  list="$(to_install "${versions[*]}" "$(rbenv whence ruby)")"
  if [[ "$list" ]]; then
    e_header "Installing Ruby versions: $list"
    for version in $list; do rbenv install "$version"; done
    [[ "$(echo "$list" | grep -w "${versions[0]}")" ]] && rbenv global "${versions[0]}"
    rbenv rehash
  fi
fi

# Install Gems.
if [[ "$(type -P gem)" ]]; then
  gems=(bundler awesome_print pry lolcat)

  list="$(to_install "${gems[*]}" "$(gem list | awk '{print $1}')")"
  if [[ "$list" ]]; then
    e_header "Installing Ruby gems: $list"
    gem install $list
    rbenv rehash
  fi
fi
