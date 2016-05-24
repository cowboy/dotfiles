#!/bin/env zsh

# Link the bullet train theme into the zsh directory
[ -f ~/.dotfiles/libs/oh-my-zsh/themes/bullet-train.zsh-theme ] \
    || ln -s ~/.dotfiles/libs/bullet-train/bullet-train.zsh-theme ~/.dotfiles/libs/oh-my-zsh/themes
