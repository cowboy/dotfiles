# rbenv init.
PATH=$PATH:$HOME/.rbenv/shims:$HOME/.rbenv/bin
export PATH
export RBENV_ROOT=/usr/local/var/rbenv

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

alias r="rails"
alias kd="knife digital_ocean"
alias kb="knife bootstrap"
alias kl="knife linode"
alias cg="chef generate"