# Editing

if [[ ! "$SSH_TTY" && "$OSTYPE" =~ ^darwin ]]; then
  export EDITOR='mate -w'
  export LESSEDIT='mate -l %lm %f'
  alias q="mate"
else
  export EDITOR=$(type nano pico vi vim 2>/dev/null | sed "s/ .*$//;q")
  alias q="$EDITOR -w -z"
fi

export VISUAL="$EDITOR"

alias qs="q ~/.dotfiles"
