#my java setup where needed

#export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/CurrentJDK/Home
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_75.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_31.jdk/Contents/Home

# JENV section here. Remember the following for troubleshooting
# unset JAVA_HOME
#
# jenv doctor
#
# brew cask install java
#
# jenv add /Library/Java/JavaVirtualMachines/jdk1. (TAB)
#
# jenv rehash
# jenv versions
#installing jenv for managing multiple versions
unset JAVA_HOME
if which jenv > /dev/null; then eval "$(jenv init -)"; fi
