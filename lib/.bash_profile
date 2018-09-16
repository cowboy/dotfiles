if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# set PATH so it includes user's private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH"
