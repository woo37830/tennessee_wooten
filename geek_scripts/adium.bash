#!/bin/bash

#http://thememymac.com/2009/geektool/geektool-all-the-scripts-i-could-find-explained-for-beginners/

mypath=$1

osascript $mypath/adium.scpt 2>&1 #| awk '{ print "Now Playing: " $0}'
echo
