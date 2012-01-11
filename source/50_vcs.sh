
# Git shortcuts

alias g='git'
alias ga='git add'
alias gp='git push'
alias gu='git pull'
alias gl='git log'
alias gg='gl --decorate --oneline --graph --date-order --all'
alias gs='git status'
alias gst='gs'
alias gd='git diff'
alias gdc='gd --cached'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gba='git branch -a'
alias gc='git checkout'
alias gco='gc'
alias gra='git remote add'
alias grr='git remote rm'
alias gcl='git clone'

# OSX-specific Git shortcuts
if [[ "$OSTYPE" =~ ^darwin ]]; then
  alias gdk='git ksdiff'
  alias gdkc='gdk --cached'
  alias gt='gittower -s'
fi
