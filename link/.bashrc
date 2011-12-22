# Add binaries into the path
PATH=$PATH:~/.dotfiles/bin
export PATH

# Source all files in ~/.dotfiles/source/
function src() {
  local file
  for file in ~/.dotfiles/source/*; do
    source "$file"
  done
}

# Run dotfiles script, then source.
function dotfiles() {
  ~/.dotfiles/bin/dotfiles $@ && src
}

src
