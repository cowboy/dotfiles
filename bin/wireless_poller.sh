#!/bin/bash

# wireless.poller.sh
# A script to poll for wireless signal strength, to determine optimal location

while x=1;
    do /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep CtlRSSI;
    sleep 0.5;
done;
