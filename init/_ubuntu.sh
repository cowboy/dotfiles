# Ubuntu-only stuff. Abort if not Ubuntu.
[[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1

# Update apt
sudo apt-get update
sudo apt-get -qqy upgrade

# Install tools and programs.
sudo apt-get -qqy install build-essential
sudo apt-get -qqy install git-core
sudo apt-get -qqy install nodejs
sudo apt-get -qqy install ruby rubygems1.8
sudo apt-get -qqy install tree sl lesspipe
