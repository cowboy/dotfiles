#!/usr/bin/env bash
SRC=https://gist.githubusercontent.com/jesperronn/45337ae0410f0fa9fa9351a67a3caa20/raw/gradle-tab-completion.bash
DST=~/bin/.gradle-tab-completion.bash
mkdir -p ~/bin/
curl $SRC -o $DST

#Then I added to my ~/.bash_profile file the following 'execute if it exists' code:

#DST=~/bin/.gradle-completion.bash
# if [ -f $DST ]; then
#   . $DST
# fi
