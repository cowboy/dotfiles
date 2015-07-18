alias podsetup="mkdir -p ~/.cocoapods/repos &>/dev/null;git clone --depth=1 https://git.oschina.net/lexrus/specs.git $HOME/.cocoapods/repos/master 2>/dev/null; git -C ~/.cocoapods/repos/master/ remote set-url origin https://github.com/CocoaPods/Specs.git"
alias podsync="git -C ~/.cocoapods/repos/master/ remote set-url origin https://git.oschina.net/lexrus/specs.git;/usr/bin/env pod repo update;git -C ~/.cocoapods/repos/master/ remote set-url origin https://github.com/CocoaPods/Specs.git"
alias podinstall="pod install --no-repo-update"
alias podupdate="pod update --no-repo-update"
alias ox="open ./*.xcworkspace 2>/dev/null || open ./*.xcodeproj 2>/dev/null"
alias xcb="sudo xcode-select -s /Applications/Xcode-beta.app/Contents/Developer/"
alias xc="sudo xcode-select -s /Applications/Xcode.app/Contents/Developer/"
alias xcp="open $HOME/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins"
alias ded="rm -rf $HOME/Library/Developer/Xcode/DerivedData"
alias fucksim="sudo killall -9 Xcode 'iOS Simulator' com.apple.CoreSimulator.CoreSimulatorService && rm -rf ~/Library/Developer/CoreSimulator/Devices"

# Add new UUID of Xcode-beta to plugins
alias xcbplug="find ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins -name Info.plist -maxdepth 3 | xargs -I{} defaults write {} DVTPlugInCompatibilityUUIDs -array-add `defaults read /Applications/Xcode-beta.app/Contents/Info DVTPlugInCompatibilityUUID`"

# Add new UUID of Xcode to plugins
alias xcplug="find ~/Library/Application\ Support/Developer/Shared/Xcode/Plug-ins -name Info.plist -maxdepth 3 | xargs -I{} defaults write {} DVTPlugInCompatibilityUUIDs -array-add `defaults read /Applications/Xcode.app/Contents/Info DVTPlugInCompatibilityUUID`"

# Workaround for openning Xcode 6.3.2 in El Capitan DP 2
alias xc6="/Applications/Xcode.app/Contents/MacOS/Xcode </dev/null &>/dev/null &"

# Debugging Xcode Plugins
# https://coderwall.com/p/-mgtww
alias xcd='xcode-debug'
