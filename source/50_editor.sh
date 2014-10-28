# Editing

if [[ ! "$SSH_TTY" ]] && is_osx; then
  export EDITOR='mvim'
  export LESSEDIT='mvim ?lm+%lm -- %f'
else
  export EDITOR='vim'
fi

export VISUAL="$EDITOR"
alias q="$EDITOR"
alias q.="q ."
alias qv="q $DOTFILES/link/.{,g}vimrc"
alias qs="q +'cd $DOTFILES'"
