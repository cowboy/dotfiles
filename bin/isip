#!/usr/bin/env bash

if [[ "$1" == "-h" || "$1" == "--help" ]]; then cat <<HELP
Get all bound IPs
http://benalman.com/

Usage: $(basename "$0") [IP]

If an IP is specified and it is bound to a network interface, echo it,
otherwise echo nothing.

Copyright (c) 2012 "Cowboy" Ben Alman
Licensed under the MIT license.
http://benalman.com/about/license/
HELP
exit; fi

iplist=$(ifconfig -a | perl -nle'/inet (?:addr:)?(\d+\.\d+\.\d+\.\d+)/ && print $1')

if [ "$1" ]; then
  if [ "$(echo $iplist | grep -w $1)" ]; then
    echo $1
  fi
else
  echo $iplist
fi
