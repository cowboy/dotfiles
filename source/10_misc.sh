# From http://stackoverflow.com/questions/370047/#370255
function path_remove() {
  IFS=:
  # convert it to an array
  t=($PATH)
  unset IFS
  # perform any array operations to remove elements from the array
  t=(${t[@]%%$1})
  IFS=:
  # output the new array
  echo "${t[*]}"
}

# Run a command with non-superuser privileges.
function unsudo() {
  e_arrow "!!! Running \"$@\" as $SUDO_USER."
  sudo -u "$SUDO_USER" bash -c 'sudo -k'
  sudo -u "$SUDO_USER" "$@"
}
export -f unsudo
