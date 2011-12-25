# OSX-only stuff. Abort if not OSX.
[[ "$OSTYPE" =~ ^darwin ]] || return 1

# APPLE, Y U PUT /usr/bin B4 /usr/local/bin?!
PATH=/usr/local/bin:$PATH
export PATH

# Trim new lines and copy to clipboard
alias c="tr -d '\n' | pbcopy"

# Make 'less' more.
eval "$(lesspipe.sh)"

# Hopefully this will get "fixed" soon.
# https://github.com/sstephenson/ruby-build/issues/109
# Also see init/osx.sh
[[ "$CC" ]] || CC="$(
  shopt -s nullglob
  gccs=(/usr/local/bin/gcc-*)
  echo "${gccs[0]}"
)"
