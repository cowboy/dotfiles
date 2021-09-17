if [[ "$(which powerline-go)" ]]; then
  # Installed by homebrew on MacOS
  powerline_go_cmd=powerline-go
elif [[ -x ${GOPATH:-~/go}/bin/powerline-go ]]; then
  # Installed manually (for now) via
  # go get -u github.com/justjanne/powerline-go
  powerline_go_cmd=${GOPATH:-~/go}/bin/powerline-go
else
  return
fi

function _update_ps1() {
  PS1="$($powerline_go_cmd \
    -static-prompt-indicator \
    -cwd-mode plain \
    -numeric-exit-codes \
    -error $? \
    -modules termtitle,time,venv,user,ssh,cwd,perms,git,hg,jobs,newline,exit,root \
  )"
}

# Ensure exit code is reset when pressing "enter" with no command
# because I'm OCD.
__prompt_stack=()
trap '__prompt_stack=("${__prompt_stack[@]}" "$BASH_COMMAND")' DEBUG

function __prompt_exit_code() {
  local exit_code=$?
  # If the first command in the stack is __prompt_command, no command was run.
  # Set exit_code to 0.
  [[ "${__prompt_stack[0]}" == "__prompt_exit_code" ]] && exit_code=0
  # Return the (correct) exit code.
  return $exit_code
}

function __prompt_cleanup() {
  # Reset the stack.
  __prompt_stack=()
}

PROMPT_COMMAND='__prompt_exit_code;_update_ps1;__prompt_cleanup'
