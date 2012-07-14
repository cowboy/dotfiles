export PATH

# rbenv init.
if [[ "$(type -P rbenv)" && ! "$(type -t _rbenv)" ]]; then
  eval "$(rbenv init -)"
  PATH=$PATH:~/.dotfiles/libs/rbenv/bin:~/.dotfiles/libs/ruby-build/bin
fi

# nave init.
if [[ "$(type -P nave)" ]]; then
  node_path=~/.nave/installed/$(nave ls | awk '/^default/ {print $2}')/bin
  if [[ -d "$node_path" ]]; then
    PATH=$node_path:$PATH
  fi
fi
