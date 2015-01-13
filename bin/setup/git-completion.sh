#!/usr/bin/env bash
SRC=https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
DST=~/bin/.git-completion.bash
# http://apple.stackexchange.com/questions/55875/have-git-autocomplete-branches-at-the-command-line
curl $SRC -o $DST

#Then I added to my ~/.bash_profile file the following 'execute if it exists' code:

#DST=~/bin/.git-completion.bash
# if [ -f $DST ]; then
#   . $DST
# fi
