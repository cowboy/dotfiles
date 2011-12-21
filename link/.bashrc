# Add binaries into the path
PATH=$PATH:~/.dotfiles/bin/
export PATH

# Source all files in ~/.dotfiles/source/
function src() {
  local FILE
  for FILE in ~/.dotfiles/source/*; do
    source "$FILE"
  done
}

# Run dotfiles script, then source.
alias dotfiles='~/.dotfiles/bin/dotfiles && src'

src
