# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# XCode and the Command Line Tools really need to be installed first.
if [[ ! -d "$('xcode-select' -print-path 2>/dev/null)" ]]; then
  echo "XCode and the Command Line Tools must be installed first."
  exit 1
fi

# Newer OS X XCode comes with an LLVM gcc which some tools (rbenv) can't use.
function get_non_llvm_gcc() {
  shopt -s nullglob
  local gccs=(/usr/local/bin/gcc-* /usr/bin/gcc-*)
  shopt -u nullglob
  local gcc=$(type -P gcc)
  [[ "$gcc" ]] && gccs=("${gccs[@]}" "$gcc")
  for gcc in "${gccs[@]}"; do
    if [[ ! "$("$gcc" --version 2> /dev/null | grep -i LLVM)" ]]; then
      echo "$gcc"
      return
    fi
  done
}

if [[ ! "$(get_non_llvm_gcc)" ]]; then
  pkg="GCC-10.7-v2.pkg"
  e_header "Installing non-LLVM GCC from $pkg"
  curl -fSL# -o "/tmp/$pkg" https://github.com/downloads/kennethreitz/osx-gcc-installer/$pkg
  sudo installer -pkg "/tmp/$pkg" -target /
fi

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
fi
