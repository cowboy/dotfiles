#!/usr/bin/env sh
while read line
do
  [ "${line###*}" ] && brew $line
done < Brewfile
