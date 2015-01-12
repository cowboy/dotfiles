#!/usr/bin/env bash

# http://apple.stackexchange.com/questions/55875/have-git-autocomplete-branches-at-the-command-line
curl https://raw.github.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
#Then I added to my ~/.bash_profile file the following 'execute if it exists' code:

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi
