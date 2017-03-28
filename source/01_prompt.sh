# Allow prompt to be restored to default.
if [[ "${#__PROMPT_DEFAULT[@]}" == 0 ]]; then
  __PROMPT_DEFAULT=("$PS1" "$PS2" "$PS3" "$PS4")
fi

function prompt_default() {
  unset PROMPT_COMMAND
  for i in {1..4}; do
    eval "PS$i='${__PROMPT_DEFAULT[i-1]}'"
  done
}
