
if [ -f $HOME/.rvm/bin ]; then
    PATH=$PATH:$HOME/.rvm/bin
    source $HOME/.rvm/scripts/rvm
elif [ -f /usr/bin/rvm ]; then
    PATH=$PATH:/usr/bin/rvm/bin
    source /usr/bin/rvm/scripts/rvm
fi

