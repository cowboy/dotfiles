# Add rbenv and ruby-build binaries into the path.
PATH=$PATH:~/.dotfiles/libs/rbenv/bin:~/.dotfiles/libs/ruby-build/bin
export PATH

# init.
[[ "$(type -P rbenv)" && ! "$(type -t _rbenv)" ]] && eval "$(rbenv init -)"
