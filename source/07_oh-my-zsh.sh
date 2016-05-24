# Path to your oh-my-zsh installation.
export ZSH=$HOME/.dotfiles/libs/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="bullet-train"

# disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh
