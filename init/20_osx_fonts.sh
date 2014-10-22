# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# Copy fonts
fonts=()
for f in ~/.dotfiles/conf/osx/fonts/*; do
  [[ -e "$HOME/Library/Fonts/$(basename "$f")" ]] || fonts=("${fonts[@]}" "$f")
done

if [[ ${#fonts[@]} != 0 ]]; then
  e_header "Copying fonts (${#fonts[@]})"
  for f in "${fonts[@]}"; do
    cp "$f" "$HOME/Library/Fonts/"
  done
fi
