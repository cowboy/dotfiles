#!/bin/bash

# 40_vim.sh
# Script to install vim modlues and powerline fonts

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
[ -d ~/.vim/bundle/vim-sensible ] || \
    ln -s ~/.dotfiles/libs/vim-sensible ~/.vim/bundle/vim-sensible
[ -d ~/.vim/bundle/neocomplete.vim ] || \
    ln -s ~/.dotfiles/libs/neocomplete.vim ~/.vim/bundle/neocomplete.vim
[ -d ~/.vim/bundle/neosnippet.vim ] || \
    ln -s ~/.dotfiles/libs/neosnippet.vim ~/.vim/bundle/neosnippet.vim
[ -d ~/.vim/bundle/neosnippet-snippets ] || \
    ln -s ~/.dotfiles/libs/neosnippet-snippets ~/.vim/bundle/neosnippet-snippets
[ -d ~/.vim/bundle/syntastic ] || \
    ln -s ~/.dotfiles/libs/syntastic ~/.vim/bundle/syntastic
[ -d ~/.vim/bundle/unite.vim ] || \
    ln -s ~/.dotfiles/libs/unite.vim ~/.vim/bundle/unite.vim
if [ ! -d ~/.vim/bundle/vimproc.vim ]; then
    cd ~/.dotfiles/libs/vimproc.vim
    make
    cp -r autoload/* ~/.vim/autoload
    ln -s ~/.dotfiles/libs/vimproc.vim ~/.vim/bundle/vimproc.vim
fi
