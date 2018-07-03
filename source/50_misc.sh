# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

alias grep='grep --color=auto'

# Prevent less from clearing the screen while still showing colors.
export LESS=-XR

# Set the terminal's title bar.
function titlebar() {
  echo -n $'\e]0;'"$*"$'\a'
}

# SSH auto-completion based on entries in known_hosts.
if [[ -e ~/.ssh/known_hosts ]]; then
  complete -o default -W "$(cat ~/.ssh/known_hosts | sed 's/[, ].*//' | sort | uniq | grep -v '[0-9]')" ssh scp sftp
fi

# Disable ansible cows }:]
export ANSIBLE_NOCOWS=1

# "fuck"
if [[ "$(which thefuck)" ]]; then
  eval $(thefuck --alias)
fi

# Run a command repeatedly in a loop, with a delay (defaults to 1 sec).
# Usage:
#   loop [delay] single_command [args]
#   loopc [delay] 'command1 [args]; command2 [args]; ...'
# Note, these do the same thing:
#   loop 5 bash -c 'echo foo; echo bar;
#   loopc 5 'echo foo; echo bar'
function loopc() { loop "$@"; }
function loop() {
  local caller=$(caller 0 | awk '{print $2}')
  local delay=1
  if [[ $1 =~ ^[0-9]*(\.[0-9]+)?$ ]]; then
    delay=$1
    shift
  fi
  while true; do
    if [[ "$caller" == "loopc" ]]; then
      bash -c "$@"
    else
      "$@"
    fi
    sleep $delay
  done
}
