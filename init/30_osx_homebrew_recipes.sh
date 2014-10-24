# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# Exit if Homebrew is not installed.
[[ "$(type -P brew)" ]] || return 1

# Homebrew recipes
recipes=(
  bash
  cowsay
  git
  git-extras
  htop-osx
  hub
  id3tool
  lesspipe
  man2html
  mercurial
  nmap
  sl
  ssh-copy-id
  the_silver_searcher
  tree
)

brew_install_recipes
