export PATH=~/local/lib/node_modules:$PATH
export PATH=$HOME/local/bin:$PATH
export PATH=~/.composer/vendor/bin:$PATH
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
findHere(){
	grep -rnw . -e "$1"
}

alias gpl="git pull origin master" # pull latest 
alias gprel="git pull origin release-1" # push 
alias gpl="git pull origin master" # pull latest 
alias gcm="git checkout master" # checkout master
alias gs="git status" # git status
alias gt="git fetch --tags ; git tag | sort -V" #fetch new tags and show current tags
alias gta=tagForDeployment # tag for deployment use param
alias gc=commitWithComment # Git commit with comment
alias gpt="git push origin --tags" # push the tags to origin
alias gtp="git push origin --tags" # push the tags to origin
alias gcma=commitAddWithComment # Git commit with comment
alias cmpu="composer update -vvv" #composer update
alias cmpd="composer dump-autoload -o" #composer dump autoload file
alias gtap=createNewTag #get tags, increment a new tag
alias apre="sudo service apache2 reload"
alias findhere=findHere

# laravel
alias dbmr="php artisan migrate:refresh --seed"
alias dbm="php artisan migrate --seed"

# access and error logs
alias tailaccess="tail -f /var/log/apache2/access.log"
alias tailerror="tail -f /var/log/apache2/error.log"
alias mysshkey="cat ~/.ssh/id_rsa.pub"
