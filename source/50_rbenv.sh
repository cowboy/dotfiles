# Add rbenv and ruby-build binaries into the path.
PATH=$PATH:~/.dotfiles/libs/rbenv/bin:~/.dotfiles/libs/ruby-build/bin
export PATH

# rbenv requires a non-LLVM gcc. So, attempt to find one.
# Note this issue:
# https://github.com/sstephenson/ruby-build/issues/109
export RBENV_CC="$(
  shopt -s nullglob
  gccs=(/usr/local/bin/gcc-* /usr/bin/gcc-*)
  gcc=$(type -P gcc)
  [[ "$gcc" ]] && gccs=("${gccs[@]}" "$gcc")
  for gcc in "${gccs[@]}"; do
    if [[ ! "$("$gcc" --version 2> /dev/null | grep -i LLVM)" ]]; then
      echo "$gcc"
      return
    fi
  done
)"

# init.
[[ "$(type -P rbenv)" && ! "$(type -t _rbenv)" ]] && eval "$(rbenv init -)"

alias rbenv='CC="$RBENV_CC" rbenv'
