#!/bin/bash

# temperature
# outputs the temperature information

# requires the following packages
# hddtemp
# lm-sensors

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

sensors
sudo hddtemp /dev/sd{b,c,d}
