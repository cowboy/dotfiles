# Download Vim plugins.
if [[ "$(type -P vim)" ]]; then
  vim +PlugUpgrade +PlugUpdate +qall
fi

# Backups, swaps and undos are stored here.
mkdir -p $dotfiles_dir/caches/vim
