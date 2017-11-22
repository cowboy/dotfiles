#!/bin/env bash
#
# fetch .osx from Mathias Bynen's .dotfiles project, since I intend
# to use some of it, but not all.
#
# This is a script to keep `mathiasbynens-dotfiles-osx` up-to-date
# my modified version is .osx here in this folder
SRC=https://raw.githubusercontent.com/mathiasbynens/dotfiles/master/.osx
DST=$DOTFILES/bin/setup/mathiasbynens-dotfiles-osx

# http://apple.stackexchange.com/questions/55875/have-git-autocomplete-branches-at-the-command-line
curl "$SRC" -o "$DST"
