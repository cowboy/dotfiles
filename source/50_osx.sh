# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# APPLE, Y U PUT /usr/bin B4 /usr/local/bin?!
PATH=/usr/local/bin:$PATH
export PATH

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Make 'less' more.
eval "$(lesspipe.sh)"

# Create a new Ubuntu Parallels VM from backup, replacing the last one.
function ubuntu_new() {
  local vm_dir="$HOME/Documents/Parallels"
  local vm_orig="$vm_dir/Ubuntu_Backup.pvm"
  local vm_new="$vm_dir/Ubuntu.pvm"
  rm -rf "$vm_new"
  cp -R "$vm_orig" "$vm_new"
  open -g "$vm_new"
}
