# Source all files in ~/.dotfiles/source/
for file in $HOME/.dotfiles/source/*; do
  source "$file"
done
