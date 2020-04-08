#!/bin/bash

# http://www.ryanlineker.com/geektool-scripts/
bold=$(tput bold)
normal=$(tput sgr0)

scutil --get ComputerName;
shopt -s extglob
output=`ioreg -l | grep IOPlatformSerialNumber | tr "|" " " | tr "\"" " " | sed "s/IOPlatform//g"` 
output="${output##*( )}"
#echo -n "${bold}"
echo "${output}"
#echo -n "${normal}"
shopt -u extglob
sw_vers | awk -F':\t' '{print $2}' | paste -d ' ' - - - ;
sysctl -n hw.memsize | awk '{print $0/1073741824"gb RAM"}';
sysctl -n machdep.cpu.brand_string;

