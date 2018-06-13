# Editing

export EDITOR=vim

# If mvim is installed, use it instead of native vim
if [[ "$(which mvim)" ]]; then
    EDITOR="mvim -v"
    alias vim="$EDITOR"
fi

if [[ ! "$SSH_TTY" ]]; then
  if [[ ! "$TMUX" ]]; then
    is_osx && EDITOR=mvim || EDITOR=gvim
  fi
  export LESSEDIT="$EDITOR ?lm+%lm -- %f"
  export GIT_EDITOR="$EDITOR -f"
fi

export VISUAL="$EDITOR"

function q() {
  if [[ -t 0 ]]; then
    $EDITOR "$@"
  else
    # Read from STDIN (and hide the annoying "Reading from stdin..." message)
    $EDITOR - > /dev/null
  fi
}
alias qv="q $DOTFILES/link/.{,g}vimrc +'cd $DOTFILES'"
alias qs="q $DOTFILES"

# For when you have vim on the brain
alias :q=exit
