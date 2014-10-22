# Download Vim plugins.
if [[ "$(type -P vim)" ]]; then
  vim +PlugInstall +qall
fi
