# Exit if, for some reason, ZSH is not installed.
[[ ! "$(type -P zsh)" ]] && e_error "ZSH failed to install." && return 1

if [[ ! -d $HOME/.oh-my-zsh ]]; then
  git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
fi

if ! grep -q "/usr/local/bin/zsh" "/etc/shells"; then
  echo "Add zsh to /etc/shells."
  command -v zsh | sudo tee -a /etc/shells
fi

if [[ "$SHELL" != "/usr/local/bin/zsh" ]]; then
  echo "$ZSH_NAME"
  chsh -s "$(command -v zsh)" "${USER}"
fi