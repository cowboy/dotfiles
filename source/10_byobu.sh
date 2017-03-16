# Start byobu!
_byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true

# Restore q3 layout and open editor in large pane
alias q3='__load_byobu_layout q3'
function _q3_pre() {
  [[ -d "$1" ]] && cd "$1"
  tmux rename-window "$(basename "$PWD")"
}
function _q3_post() {
  [[ -d "$1" ]] && shift
  tmux send-keys -t 2 "q $@" Enter
}

# Load an arbitrary byobu layout into the current window (if only one pane)
# otherwise into a new pane.
function __load_byobu_layout() {
  local panes layout
  panes="$(tmux list-panes | wc -l)"
  if [[ "$panes" != 1 ]]; then
    tmux new-window "bash --rcfile <(echo '. ~/.bashrc; __load_byobu_layout $*')"
    return
  fi
  layout=$1; shift
  [[ "$(type -t _${layout}_pre)" == function ]] && _${layout}_pre "$@"
  byobu-layout restore $layout && \
  [[ "$(type -t _${layout}_post)" == function ]] && _${layout}_post "$@"
}
