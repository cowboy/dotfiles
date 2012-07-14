# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# Install Homebrew.
if [[ ! "$(type -P brew)" ]]; then
  e_header "Installing Homebrew"
  /usr/bin/ruby -e "$(/usr/bin/curl -fsSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"
fi

if [[ "$(type -P brew)" ]]; then
  # Update Homebrew.
  e_header "Updating Homebrew"
  brew update

  # Install Homebrew recipes.
  recipes=(git tree sl lesspipe id3tool nmap git-extras htop man2html)

  list="$(to_install "${recipes[*]}" "$(brew list)")"
  if [[ "$list" ]]; then
    e_header "Installing Homebrew recipes: $list"
    brew install $list
  fi

  # Newer OSX XCode comes with an LLVM gcc which rbenv can't use.
  source ~/.dotfiles/source/50_rbenv.sh
  if [[ ! "$RBENV_CC" && ! "$(brew list | grep -w "gcc")" ]]; then
    e_header "Installing Homebrew-alt gcc recipe"
    echo "Note: this step can take 15+ minutes, but a non-LLVM gcc is required by rbenv."
    skip || brew install https://github.com/adamv/homebrew-alt/raw/master/duplicates/gcc.rb
  fi
fi
