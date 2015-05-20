#!/bin/bash

# temperature.sh
# outputs the temperature information

# Ensure commands are available
type -P sensors 2>&1 > /dev/null || sudo apt-get install lm-sensors
type -P hddtemp 2>&1 > /dev/null || sudo apt-get install hddtemp

# Run appropriate commands
sudo sensors
[ -e /dev/sdb ] && sudo hddtemp /dev/sdb
[ -e /dev/sdc ] && sudo hddtemp /dev/sdc
[ -e /dev/sdd ] && sudo hddtemp /dev/sdd
