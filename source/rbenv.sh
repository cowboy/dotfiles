# If CC isn't set, attempt to set it. This is used by rbenv.
# Note this issue:
# https://github.com/sstephenson/ruby-build/issues/109
[[ "$CC" ]] || export CC="$(
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

# rbenv.
[[ "$(type -P rbenv)" && ! "$(type -t _rbenv)" ]] && eval "$(rbenv init -)"
