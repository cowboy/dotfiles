export LANG=en_US.UTF-8

# Where the magic happens.
export DOTFILES=$HOME/.dotfiles

# Add binaries into the path
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/usr/local/share/npm/bin
export PATH=$PATH:/usr/local/sbin
export PATH=$PATH:/opt/local/bin:/opt/local/sbin
export PATH=$PATH:/usr/local/mysql/bin
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/Dropbox/bin
export PATH=$DOTFILES/bin:$PATH
export PATH="/usr/local/heroku/bin:$PATH"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set maximum reverse history file size
HISTSIZE=1000
# Limit items
SAVEHIST=300
# Optionally, move to another file
HISTFILE=~/.zsh_history

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="sorin"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git git-extras github brew ruby bundler gem rails rake docker redis-cli pod cp osx vagrant)

source $ZSH/oh-my-zsh.sh

# Source all files in "source"
function src() {
  local file
  for file in $DOTFILES/source/*; do
    source "$file"
  done
}

src
