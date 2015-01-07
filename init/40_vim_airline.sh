#!/bin/bash

# 40_vim_airline.sh
# Script to install vim airline with powerline fonts

echo "Installing powerline fonts..."
cd ~/.dotfiles/libs/fonts
./install.sh

echo "Hooking up .vim directories..."
mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/bundle
[ -f ~/.vim/autoload/pathogen.vim ] || \
    ln -s ~/.dotfiles/libs/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload/pathogen.vim
[ -d ~/.vim/bundle/vim-airline ] || \
    ln -s ~/.dotfiles/libs/vim-airline ~/.vim/bundle/vim-airline
[ -d ~/.vim/bundle/vim-fugitive ] || \
    ln -s ~/.dotfiles/libs/vim-fugitive ~/.vim/bundle/vim-fugitive
