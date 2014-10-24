# OS detection
all_oses=(osx ubuntu)

function is_osx() {
  [[ "$OSTYPE" =~ ^darwin ]] || return 1
}
function is_ubuntu() {
  [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1
}

function get_os() { for os in "${all_oses[@]}"; do is_$os && echo $os; done; }
function not_os() { for os in "${all_oses[@]}"; do is_$os || echo $os; done; }
