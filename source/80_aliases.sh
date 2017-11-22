alias less='less -r'
alias more='more -r'

alias pgrep='ps -ef | grep $1'

alias gw='./gradlew'

alias dcompose='docker-compose'

#shows top 10 used terms from history
#from http://stackoverflow.com/questions/68372/what-is-your-single-most-favorite-command-line-trick-using-bash#68390
alias tophist="history | awk '{print \$4}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail | sort -nr"


# Homebrew cask install of firefox. To help test runners like Karma-firefox:
export FIREFOX_BIN="/opt/homebrew-cask/Caskroom/firefox/latest/Firefox.app/Contents/MacOS/firefox-bin"

# chrome shortcut
# from https://developers.google.com/web/updates/2017/04/headless-chrome
alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias chrome-canary="/Applications/Google\ Chrome\ Canary.app/Contents/MacOS/Google\ Chrome\ Canary"
alias chromium="/Applications/Chromium.app/Contents/MacOS/Chromium"

# ssh completion
# see http://hints.macworld.com/article.php?story=20100113142633883
complete -o default -o nospace -W "$(/usr/bin/env ruby -ne 'puts $_.split(/[,\s]+/)[1..-1].reject{|host| host.match(/\*|\?/)} if $_.match(/^\s*Host\s+/);' < $HOME/.ssh/config)" scp sftp ssh



DST=~/bin/.git-completion.bash
if [ ! -f $DST ]; then
  "$DOTFILES/bin/setup/git-completion.sh"
fi
. $DST
