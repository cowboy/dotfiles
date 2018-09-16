alias dotfiles='~/.dotfiles/dotfiles'

alias tgz='_(){ tar -zcvf $1.tgz $*"; }; _'
alias xtgz='tar -zxvf'
alias sse='seesetenv'
alias ssel='seesetenv -l'
alias mkcd='_(){ mkdir -p "$*"; cd "$*"; }; _'
alias grr='grep --exclude-dir=.git --exclude-dir=.svn -PR'

alias ..='cd ..'
alias ...='cd ../..'

alias f='find . -name'
alias g='git'
alias l='ls -lah'

alias s=svn
alias t=top
alias v=vi
alias w=which

# Git
alias ga='git add'
alias gr='git rm'
alias gd='git diff --color-words'
alias gl='git log --oneline --decorate'
alias gll="git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(black)%s%C(reset) %C(black)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
alias gc='git commit'
alias gcl='git clone'
alias gs='git status -sb'
alias gr='git revert'
alias gp='git pull'
alias gpu='git push -u origin master'

# Subversion
alias sco='svn co'
alias sci='svn ci'
alias sc='svn cleanup'
alias sd='svn diff --patch-compatible --force'
alias sdd='svn diff --patch-compatible --force --diff-cmd=kdiff3_for_svn'
alias si='svn info'
alias sl='svn log'
alias sp='svn patch'
alias sr='svn revert'
alias srr='_(){ svn revert -R .; svn st --ignore-externals | grep "^?" | cut -c9- | xargs rm -rf; svn cleanup . }; _'
alias ss='svn st --ignore-externals'
alias ssa='svn st'
alias ssw='svn sw'
alias su='svn up'