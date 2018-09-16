set --global --export PATH $PATH $HOME/.gem/ruby/2.5.0/bin
set --global --export EDITOR /usr/bin/vi
set --global --export VISUAL /usr/bin/kate

alias dotfiles='~/.dotfiles/dotfiles'

# Smart aliases based on https://github.com/algotech/dotaliases
alias l='ls -lah'
alias mkcd='function _; mkdir -p $argv[1]; cd $argv[1]; end; _'
alias ..='cd ..'
alias ...='cd ../..'
alias ff='find . -name'

alias gc='git clone'
alias gs='git status'
alias ga='git add'

alias sai='sudo apt install -y'
alias sau='sudo apt update'
alias sar='sudo apt remove'
alias cx='chmod a+x'

alias tgz='function _; tar -zcvf "$argv[1].tgz" "$argv[1]"; end; _'
alias xtgz='tar -zxvf'

alias cne='function _; tar -zcvO "$argv[1]" | base64 > "$argv[1].tgz64.txt"; end; _'
alias dnx='function _; base64 --decode < "$argv[1]" | tar -zxv; end; _'
alias whos_in_lan='function _; ping -b -w1 (ip address show | string match --regex "(?<=brd )(\d{1,3}\.?){4}(?= scope)"); arp -e; end; _'

alias sizeof='du --bytes --summarize'
alias restart_kde_plasma='kquitapp5 plasmashell; kstart plasmashell 2>/dev/null; kwin --replace 2>/dev/null &'
