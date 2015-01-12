# Initialize my ruby via rvm


setopt interactivecomments

# install rvm and compile latest ruby
bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
if [[ -s ~/.rvm/scripts/rvm ]] ; then source ~/.rvm/scripts/rvm ; fi
rvm get head
rvm reload
rvm install 2.2.0
rvm use 2.2.0 --default
