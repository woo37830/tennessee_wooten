#!/bin/bash

# http://macthemes2.net/forum/viewtopic.php?id=16793954

asbreg=`ioreg -rc "AppleSmartBattery"`

maxcap=`echo "${asbreg}" | awk '/MaxCapacity/{print $3}'`;
curcap=`echo "${asbreg}" | awk '/CurrentCapacity/{print $3}'`;

prcnt=`echo "scale=2; 100*$curcap/$maxcap" | bc`;

printf "Battery: %1.0f%%\n" ${prcnt};
echo

# another way of doing it:
# http://olivia.org.pl/?p=413
#echo "Battery"
#ioreg -w0 -l | grep DesignCapacity | awk '{ print substr($0,19,50) }' | sed 's/"//g'
#ioreg -w0 -l | grep MaxCapacity | awk '{ print substr($0,19,50) }' | sed 's/"//g'
#ioreg -w0 -l | grep CurrentCapacity | awk '{ print substr($0,19,50) }' | sed 's/"//g'

#EOF
