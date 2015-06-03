# pyenv init.
export PYENV_ROOT="$HOME/.pyenv"
export PATH=$PATH:~/.pyenv/shims:/usr/local/bin:/usr/bin:/bin

if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
