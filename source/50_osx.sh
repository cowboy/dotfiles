# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# APPLE, Y U PUT /usr/bin B4 /usr/local/bin?!
PATH=/usr/local/bin:$PATH
export PATH

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Make 'less' more.
eval "$(lesspipe.sh)"

# Create a new Ubuntu testing VM from backup.
function ubuntu_new() {
  local vm_dir="/Users/cowboy/Documents/Parallels"
  local vm_orig="$vm_dir/Ubuntu Linux Backup.pvm"
  local vm_new="$vm_dir/Ubuntu Linux.pvm"
  rm -rf "$vm_new"
  cp -R "$vm_orig" "$vm_new"
  open -g "$vm_new"
}
