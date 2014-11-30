# Editing

if [[ ! "$SSH_TTY" && "$OSTYPE" =~ ^darwin ]]; then
  export EDITOR='subl -w'
  export LESSEDIT='subl %f'
  alias q='subl'
else
  export EDITOR='emacs'
  alias q="$EDITOR"
fi

export VISUAL="$EDITOR"
