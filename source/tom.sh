export PATH=/home/tom/local/lib/node_modules:$PATH
export PATH=$HOME/local/bin:$PATH
tagForDeployment(){ #function is needed for passing params when using aliases
    git tag -a $1 -m "Tag for deployment"
}
commitAddWithComment(){
    git commit -am "$1"
}
commitWithComment(){
    git commit -m "$1"
}
createNewTag(){
    git fetch --tags
    firstnr=$(git tag | sort -V | tail -1 | awk -F'.' '{ print $1 }')
    middlenr=$(git tag | sort -V | tail -1 | awk -F'.' '{ print $2 }')
    lastnr=$(git tag | sort -V | tail -1 | awk -F'.' '{ print $3 }')
    let "newnr = $lastnr + 1"
    git tag -a $firstnr.$middlenr.$newnr -m "Tag for deployment"
    git push --tags
}

alias gpl="git pull origin master" # pull latest 
alias gps="git push origin master" # push 
alias gcm="git checkout master" # checkout master
alias gs="git status" # git status
alias gt="git fetch --tags ; git tag | sort -V" #fetch new tags and show current tags
alias gta=tagForDeployment # tag for deployment use param
alias gc=commitWithComment # Git commit with comment
alias gpt="git push origin --tags" # push the tags to origin
alias gtp="git push origin --tags" # push the tags to origin
alias gcma=commitAddWithComment # Git commit with comment
alias cmpu="composer update -vvv" #composer update
alias gtap=createNewTag #get tags, increment a new tag
alias rmproxy="sudo rm -rf ~/Projects/cod-init/data/Proxy*"
alias rmassetic="sudo rm -rf ~/Projects/cod-init/public/cache/assetic/*"
alias apre="sudo service apache2 reload"

export PATH="$HOME/.phpenv/bin:$PATH"
eval "$(phpenv init -)"
