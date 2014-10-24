function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }

function assert() {
  local success modes equals expected
  modes=(e_error e_success); equals=("!=" "=="); expected="$1"; shift
  "$@"
  [[ "$assert_actual" == "$expected" ]] && success=1 || success=0
  ${modes[success]} "\"$assert_actual\" ${equals[success]} \"$expected\""
  unset assert_actual
}
