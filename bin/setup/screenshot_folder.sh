#!/bin/sh

# put all screenshots in user's $HOME/Documents/screenshots/ 
# remember to restart computer
# tip from http://www.mactipper.com/2008/02/change-default-screenshot-location.html
# put into scriptfile by Jesper Rønn-Jensen www.justaddwater.dk, last mod: 2009-10-03

DIR=$HOME/Pictures/Screenshots
mkdir -p $DIR
defaults write com.apple.screencapture location $DIR


echo "Restart your computer to make sure all screenshots go in the folder"
echo "$DIR"