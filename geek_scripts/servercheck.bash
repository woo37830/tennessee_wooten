#!/bin/bash
myserver=$1
mycommand="ping -c 1 $myserver"
$mycommand 2>&1 | awk -v server="$myserver" '/bytes/ && !/PING/{print "ping " server ": " $0 }'
mycommand="java -cp /Users/woo/bin/checkServer.jar http.TestDmeHelp"
$mycommand | grep site
#echo
