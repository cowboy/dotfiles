#!/bin/bash
#git-setup
#from http://rails.wincent.com/wiki/Git_quickstart
#modified by Jesper Rønn-Jensen to take interactive input

echo "Your name: "
read NAME
echo "Your email: "
read EMAIL

# personalize these with your own name and email address
git config --global user.name "$NAME"
git config --global user.email "$EMAIL"
