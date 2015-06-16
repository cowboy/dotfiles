# Where the magic happens.
[[ -n "$DOTFILES" ]] || export DOTFILES="$(readlink -f "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/..")"
[[ -n "$DOTFILES" ]] || export DOTFILES="~/.dotfiles"

# Add binaries into the path
PATH=$DOTFILES/bin:$PATH
export PATH

# Source all files in "source"
function src() {
  local file
  if [[ "$1" ]]; then
    source "$DOTFILES/source/$1.sh"
  else
    for file in $DOTFILES/source/*; do
      source "$file"
    done
  fi
}

# Run dotfiles script, then source.
function dotfiles() {
  $DOTFILES/bin/dotfiles "$@" && src
}

src
