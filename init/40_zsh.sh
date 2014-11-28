# Exit if, for some reason, ZSH is not installed.
[[ ! "$(type -P zsh)" ]] && e_error "ZSH failed to install." && return 1

git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
chsh -s `which zsh`