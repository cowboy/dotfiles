# This file is sourced at the end of a first-time dotfiles install.
shopt -s expand_aliases
source ~/.bashrc

# I'm forgetful. Just look at this repo's commits to see how many times I
# forgot to setup Git and GitHub.

cat <<EOF
SSH Keys (if this is a server)
 1. (main) scp ~/.ssh/id_rsa.pub $USER@$(wanip):~/.ssh/
 2. (here) cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

Git / GitHub
 1. Get GitHub API token from https://github.com/account/admin
 2. (here) git config --global github.token "omgsupersecretgithubapitoken"
 3. (here) git config --global user.email "email@domain.com"
EOF
