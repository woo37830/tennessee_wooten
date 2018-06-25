#!/bin/bash

#http://forums.macrumors.com/showthread.php?t=628023

myscriptpath=`echo $0 | rev | awk '{firstslash=index($0,"/");print substr($0,firstslash+1,length($0)); }' | rev` 

osascript $myscriptpath/itunesplaying.scpt 2>/dev/null | awk '{ print "Now Playing: " $0}'
echo
