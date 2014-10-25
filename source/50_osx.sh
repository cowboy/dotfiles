# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# APPLE, Y U PUT /usr/bin B4 /usr/local/bin?!
PATH="/usr/local/bin:$(path_remove /usr/local/bin)"
export PATH

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Make 'less' more.
[[ "$(type -P lesspipe.sh)" ]] && eval "$(lesspipe.sh)"

# Start ScreenSaver. This will lock the screen if locking is enabled.
alias ss="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"

# Create a new Parallels VM from template, replacing the existing one.
function vm_template() {
  local name="$@"
  local basename="$(basename "$name" ".zip")"
  local dest_dir="$HOME/Documents/Parallels"
  local dest="$dest_dir/$basename"
  local src_dir="$dest_dir/Templates"
  local src="$src_dir/$name"
  if [[ ! "$name" || ! -e "$src" ]]; then
    echo "You must specify a valid VM template from this list:";
    shopt -s nullglob
    for f in "$src_dir"/*.pvm "$src_dir"/*.pvm.zip; do
      echo " * $(basename "$f")"
    done
    shopt -u nullglob
    return 1
  fi
  if [[ -e "$dest" ]]; then
    echo "Deleting old VM"
    rm -rf "$dest"
  fi
  echo "Restoring VM template"
  if [[ "$name" == "$basename" ]]; then
    cp -R "$src" "$dest"
  else
    unzip -q "$src" -d "$dest_dir" && rm -rf "$dest_dir/__MACOSX"
  fi && \
  echo "Starting VM" && \
  open -g "$dest"
}

# Export Localization.prefPane text substitution rules.
function txt_sub_backup() {
  local prefs=~/Library/Preferences/.GlobalPreferences.plist
  local backup=$DOTFILES/conf/osx/NSUserReplacementItems.plist
  /usr/libexec/PlistBuddy -x -c "Print NSUserReplacementItems" "$prefs" > "$backup" &&
  echo "File ~${backup#$HOME} written."
}

# Import Localization.prefPane text substitution rules.
function txt_sub_restore() {
  local prefs=~/Library/Preferences/.GlobalPreferences.plist
  local backup=$DOTFILES/conf/osx/NSUserReplacementItems.plist
  if [[ ! -e "$backup" ]]; then
    echo "Error: file ~${backup#$HOME} does not exist!"
    return 1
  fi
  cmds=(
    "Delete NSUserReplacementItems"
    "Add NSUserReplacementItems array"
    "Merge '$backup' NSUserReplacementItems"
  )
  for cmd in "${cmds[@]}"; do /usr/libexec/PlistBuddy -c "$cmd" "$prefs"; done
}
