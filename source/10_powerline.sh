if [[ "$(which powerline-daemon)" ]]; then
  # Allow prompt to be restored to default.
  [[ "${#__PS_DEFAULT[@]}" == 0 ]] && __PS_DEFAULT=("$PS1" "$PS2" "$PS3" "$PS4")
  function prompt_default() {
    unset PROMPT_COMMAND
    for i in {1..4}; do eval "PS$i='${__PS_DEFAULT[i-1]}'"; done
  }

  # Powerline stuff.
  export POWERLINE_PREFIX="$(python -c "import site; print(site.getusersitepackages())")/powerline"

  powerline-daemon -q
  export POWERLINE_BASH_CONTINUATION=1
  export POWERLINE_BASH_SELECT=1

  unset PROMPT_COMMAND
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

  # Conditionally change the powerline config.
  __powerline_command_args=()
  __powerline_command_prefix=' -t cowboy.'

  # Run at any time to remove extra stuff from the prompt.
  function prompt_simple() {
    __temp=(date_seg hostname battery uptime system_load external_ip internal_ip)
    function __temp() { echo "segment_data.$1.display=false"; }
    __powerline_command_args=($(array_map __temp __temp))
    unset __temp; unset -f __temp
    __set_powerline_command_args
  }

  function __set_powerline_command_args() {
    POWERLINE_COMMAND_ARGS=
    if [[ "${#__powerline_command_args[@]}" != 0 ]]; then
      POWERLINE_COMMAND_ARGS="$__powerline_command_prefix$(array_join __powerline_command_args "$__powerline_command_prefix")"
    fi
  }

  # If not in a login shell (eg. "sudo bash") or inside a tmux pane, simplify
  # the prompt automatically.
  if ! shopt -q login_shell || [[ "$TMUX" ]]; then
    prompt_simple
  else
    __set_powerline_command_args
  fi
fi
