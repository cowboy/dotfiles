#!/bin/bash
# Fedora-only stuff. Abort if not Fedora.
is_fedora || return 1

# Script to install Fedy <http://folkswithhats.org/>.
# Copyright (C) 2014  Satyajit sahoo

sudo rpm --quiet --query folkswithhats-release || dnf -y --nogpgcheck install https://www.folkswithhats.org/repo/$(rpm -E %fedora)/RPMS/noarch/folkswithhats-release-1.0.1-1.fc$(rpm -E %fedora).noarch.rpm
sudo rpm --quiet --query rpmfusion-free-release || dnf -y --nogpgcheck install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo rpm --quiet --query rpmfusion-nonfree-release || dnf -y --nogpgcheck install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo "Installing fedy..."

sudo dnf -y --nogpgcheck install fedy