#!/bin/bash

#
# See Linux Server Hacks #54
# $Id: whosOnPort.sh,v 1.5 2007/03/28 06:50:09 oracle Exp $
#

port=$1
# get the process info (pid/name). restricted to tcp only
procinfo=$( netstat --numeric-ports -nlp 2> /dev/null | \
            grep ^tcp | grep -w ${port} | tail -n 1 | awk '{print $7}' )

case "${procinfo}" in
"")
  echo "No process listening on port ${port}"
  ;;

"-")
  echo "Process is running on ${port}, but current user does not have rights to see process information."
  ;;

*)
  echo "${procinfo} is running on port ${port}"
  ps uwep ${procinfo%/*}
  ;;

esac

