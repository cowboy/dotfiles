if [[ "$(which powerline-daemon)" ]]; then
  unset PROMPT_COMMAND

  # Powerline stuff.
  export POWERLINE_PREFIX="$(python -c "import site; print(site.getusersitepackages())")/powerline"
  powerline-daemon -q
  export POWERLINE_BASH_CONTINUATION=1
  export POWERLINE_BASH_SELECT=1
  . $POWERLINE_PREFIX/bindings/bash/powerline.sh

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

  PROMPT_COMMAND=$'__prompt_exit_code\n'"$PROMPT_COMMAND"$'\n__prompt_cleanup'

  # Conditionally chane the powerline config.
  powerline_command_args=()
  powerline_command_prefix=' -t cowboy.'
  # If not in a login shell (eg. "sudo bash") or inside a tmux pane:
  if ! shopt -q login_shell || [[ "$TMUX" ]]; then
    powerline_command_args+=(
      segment_data.date-seg.display=false
    )
  fi
  if [[ "${#powerline_command_args[@]}" != 0 ]]; then
    POWERLINE_COMMAND_ARGS="$powerline_command_prefix$(array_join powerline_command_args "$powerline_command_prefix")"
  fi
fi
