# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# APPLE, Y U PUT /usr/bin B4 /usr/local/bin?!
PATH=/usr/local/bin:$PATH
export PATH

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Make 'less' more.
eval "$(lesspipe.sh)"

# Start ScreenSaver. This will lock the screen if locking is enabled.
alias ss="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app"

# Create a new Parallels VM from template, replacing the existing one.
function vm_template() {
  local vm_dir="$HOME/Documents/Parallels"
  local vm_templates_dir="$vm_dir/Templates"
  local vm_name="$@.pvm"
  local vm_backup="$vm_templates_dir/$vm_name.zip"
  if [[ ! "$@" || ! -e "$vm_backup" ]]; then
    echo "You must specify a valid VM template from this list:";
    for f in "$vm_templates_dir"/*.pvm.zip; do
      echo " * $(basename "$f" ".pvm.zip")"
    done
    return 1
  fi
  rm -rf "$vm_dir/$vm_name"
  echo "Extracting template..." &&
  unzip -q "$vm_backup" -d "$vm_dir" &&
  rm -rf "$vm_dir/__MACOSX" &&
  open -g "$vm_dir/$vm_name"
}

# Export Localization.prefPane text substitution rules.
function txt_sub_backup() {
  local prefs=~/Library/Preferences/.GlobalPreferences.plist
  local backup=~/.dotfiles/conf/osx/NSUserReplacementItems.plist
  /usr/libexec/PlistBuddy -x -c "Print NSUserReplacementItems" "$prefs" > "$backup" &&
  echo "File ~${backup#$HOME} written."
}

# Import Localization.prefPane text substitution rules.
function txt_sub_restore() {
  local prefs=~/Library/Preferences/.GlobalPreferences.plist
  local backup=~/.dotfiles/conf/osx/NSUserReplacementItems.plist
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
