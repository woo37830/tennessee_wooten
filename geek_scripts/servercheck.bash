#!/bin/bash
myserver=$1
mycommand="ping -c 1 $myserver"
$mycommand 2>&1 | awk -v server="$myserver" '/bytes/ && !/PING/{print "ping " server ": " $0 }'
mycommand="nc $myserver -z 22"
$mycommand
if [ -f http.TestDmeHelp ]; then
mycommand="java -cp /Users/woo/bin/checkServer.jar http.TestDmeHelp"
$mycommand | grep site
fi
#echo
