#!/bin/bash

# need.reboot.sh
# A script to check whether reboot is required
# Copied from http://askubuntu.com/questions/164/how-can-i-tell-from-the-command-line-whether-the-machine-requires-a-reboot

if [ -f /var/run/reboot-required ]; then
    echo 'Reboot required'
else
    echo 'No reboot required'
fi


