# Start byobu!
_byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true

# Restore q3 layout and open editor in large pane
alias q3='run_in_fresh_tmux_window __q3'
function __q3() {
  local is_dir=
  [[ -d "$1" ]] && is_dir=1 && cd "$1"
  tmux rename-window "$(basename "$PWD")"
  byobu-layout restore q3
  [[ "$is_dir" ]] && shift
  tmux send-keys -t 2 "q $@" Enter
}

# Run an arbitrary command in the current tmux window (if only one pane)
# otherwise create a new window and run the command there.
function run_in_fresh_tmux_window() {
  local panes="$(tmux list-panes | wc -l)"
  if [[ "$panes" != 1 ]]; then
    tmux new-window "bash --rcfile <(echo '. ~/.bashrc; $*')"
  else
    "$@"
  fi
}
