alias podsync="git -C ~/.cocoapods/repos/master/ remote set-url origin https://git.oschina.net/lexrus/specs.git;/usr/bin/env pod repo update;git -C ~/.cocoapods/repos/master/ remote set-url origin https://github.com/CocoaPods/Specs.git"
alias podinstall="pod install --no-repo-update"
alias podupdate="pod update --no-repo-update"
alias ox="open ./*.xcworkspace 2>/dev/null || open ./*.xcodeproj 2>/dev/null"
alias stopa2="sudo serveradmin stop web"
alias starta2="sudo serveradmin start web"
alias restartnginx="sudo lunchy restart nginx"

# Debugging Xcode Plugins
# https://coderwall.com/p/-mgtww
alias xcd='xcode-debug'

# Clear Xcode DerivedData
alias ded="rm -rf $HOME/Library/Developer/Xcode/DerivedData"