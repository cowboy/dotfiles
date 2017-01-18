# Editing

if [[ ! "$SSH_TTY" ]] && is_osx; then
  export EDITOR='nano'
  export LESSEDIT='mvim ?lm+%lm -- %f'
else
  export EDITOR='nano'
fi

export VISUAL="$EDITOR"
alias q="$EDITOR"
alias qv="q $DOTFILES/link/.{,g}vimrc +'cd $DOTFILES'"
alias qs="vim $DOTFILES"
