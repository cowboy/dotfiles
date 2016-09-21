#!/bin/bash
#source .
#set -x





#Config: ~/Library/Preferences/ID
#System: ~/Library/Caches/ID
#Plugins: ~/Library/Application Support/ID
#Logs: ~/Library/Logs/ID
NAMES=$(echo "ID11 ID13 ID14 ID15 ID2016.1 ID2016.2 RM50 RM60 RM70 RM80" | sed s/ID/IntelliJIdea/g | sed s/RM/RubyMine/g )
for name in $NAMES; do
  echo "info: ~/Library/Preferences/$name:" #TODO more info here
done
