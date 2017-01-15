#!/bin/sh
 
if ps -aux | grep -v grep | grep "queue db processQueue"  > /dev/null
then
    echo "queue is running, everything is fine"
else
    echo "QUEUE is not running"
    echo "QUEUE is not running!" | mail -s "QUEUE down" "tom.somerville@4mation.com.au"
fi
