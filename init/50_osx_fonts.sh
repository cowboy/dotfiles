# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Copy fonts
{
  pushd $DOTFILES/conf/osx/fonts/; setdiff_new=(*); popd
  pushd ~/Library/Fonts/; setdiff_cur=(*); popd
  setdiff; fonts=("${setdiff_out[@]}")
  unset setdiff_new setdiff_cur setdiff_out
} >/dev/null

if (( ${#fonts[@]} > 0 )); then
  e_header "Copying fonts (${#fonts[@]})"
  for f in "${fonts[@]}"; do
    e_arrow "$f"
    cp "$DOTFILES/conf/osx/fonts/$f" ~/Library/Fonts/
  done
fi
