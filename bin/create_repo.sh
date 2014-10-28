#!/bin/bash

# create_repo.sh
# create a new mercurial repository

# Check if script is run by root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Set arguments to variables
group=$1
repo=$2
description=$3

# Define usage
function usage {
    echo "Usage: $0 <group> <repo> <description>"
    exit
}

# validate parameters
if [ "$group" = "" ]; then
    usage
elif [ "$repo" = "" ]; then
    usage
else
    echo "Creating new repo ($repo) in group ($group)"
fi


# Check group directory exists
groupdir="/data/hg/$group"
if [ ! -d $groupdir ]; then
    echo "Group dir doesn't exist"
fi

echo "Creating repository..."
cd $groupdir
sudo mkdir $repo
cd $repo
sudo hg init
sudo echo "[web]" > .hg/hgrc
sudo echo "description = $description" >> .hg/hgrc
cd $groupdir
sudo echo "$repo = $repo" >> hgweb.config
sudo chown -R www-data:www-data $repo

echo "Adding to trac..."
sudo echo "$repo.dir = $groupdir/$repo" >> $groupdir/trac/conf/trac.ini
sudo echo "$repo.description = $description" >> $groupdir/trac/conf/trac.ini
sudo echo "$repo.type = hg" >> $groupdir/trac/conf/trac.ini

echo "Restarting apache..."
sudo service apache2 restart

echo "done."
