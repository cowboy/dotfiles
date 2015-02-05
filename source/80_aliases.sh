alias less='less -r'

alias pgrep='ps -ef | grep $1'

#postgres related:
alias pgstart='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pg_start='launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist'
alias pgstop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

#shows top 10 used terms from history
#from http://stackoverflow.com/questions/68372/what-is-your-single-most-favorite-command-line-trick-using-bash#68390
alias tophist="history | awk '{print \$2}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail | sort -nr"


#export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_75.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_31.jdk/Contents/Home

# Homebrew cask install of firefox. To help test runners like Karma-firefox:
export FIREFOX_BIN="/opt/homebrew-cask/Caskroom/firefox/latest/Firefox.app/Contents/MacOS/firefox-bin"


DST=~/bin/.git-completion.bash
if [ ! -f $DST ]; then
  "$DOTFILES/bin/setup/git-completion.sh"
fi
. $DST
