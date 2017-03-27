if [[ "$SUDO_USER" ]]; then
  # Ensure ~/.local/bin is in path when sudoing. This allows locally-installed
  # powerline to function in "sudo bash"
  PATH="$(path_remove "$HOME/.local/bin"):$HOME/.local/bin"
fi
