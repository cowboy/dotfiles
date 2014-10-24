# Offer the user a chance to skip something.
function skip() {
  REPLY=noskip
  read -t 5 -n 1 -s -p "To skip, press X within 5 seconds. "
  if [[ "$REPLY" =~ ^[Xx]$ ]]; then
    echo "Skipping!"
  else
    echo "Continuing..."
    return 1
  fi
}

# Display a fancy menu.
# Inspired by http://serverfault.com/a/298312
function menu() {
  local exitcode prompt choices nums i n
  exitcode=0
  if [[ "$2" ]]; then
    _menu_render_items "$1"
    read -t $2 -n 1 -sp "To edit this list, press any key within $2 seconds. "
    exitcode=$?
    echo ""
  fi 1>&2
  if [[ "$exitcode" == 0 ]]; then
    prompt="Toggle options (Separate options with spaces, ENTER when done): "
    while _menu_render_items "$1" 1 && read -rp "$prompt" nums && [[ "$nums" ]]; do
      _menu_add_results $nums
    done
  fi 1>&2
  _menu_add_results
}

function _menu_iter() {
  local i sel state
  local fn=$1; shift
  for i in ${!menu_options[@]}; do
    state=0
    for sel in ${menu_selects[@]}; do
      [[ "$sel" == "${menu_options[i]}" ]] && state=1 && break
    done
    $fn $state $i "$@"
  done
}

function _menu_render_items() {
  e_header "$1"
  _menu_iter _menu_render_item "$2"
}

function _menu_render_item() {
  local modes=(error success)
  if [[ "$3" ]]; then
    e_${modes[$1]} "$(printf "%2d) %s\n" $(($2+1)) "${menu_options[$2]}")"
  else
    e_${modes[$1]} "${menu_options[$2]}"
  fi
}

function _menu_add_results() {
  _menu_result=()
  _menu_iter _menu_add_result "$@"
  menu_selects=("${_menu_result[@]}")
}

function _menu_add_result() {
  local state i n keep match
  state=$1; shift
  i=$1; shift
  for n in "$@"; do
    if [[ $n =~ ^[0-9]+$ ]] && (( n-1 == i )); then
      match=1; [[ "$state" == 0 ]] && keep=1
    fi
  done
  [[ ! "$match" && "$state" == 1 || "$keep" ]] || return
  _menu_result=("${_menu_result[@]}" "${menu_options[i]}")
}
