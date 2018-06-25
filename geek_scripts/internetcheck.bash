#!/bin/bash
# set mynoise=1 to have echos
# set mynoise=0 to be silent
mynoise=0
myserver=google.com


mycommand="ping -c 1 $myserver"
myresult=`$mycommand 2>&1`
if [[ $myresult =~ "cannot resolve" ]]
then
  export NOINTERNET="1"
  if [ $mynoise -eq 1 ] ; then  echo "No Internet" ; fi
  if [ $mynoise -eq 1 ] ; then  echo ; fi
else
  export NOINTERNET="2"
  if [ $mynoise -eq 1 ] ; then  echo "Internet Found" ; fi
  if [ $mynoise -eq 1 ] ; then  echo ; fi
fi
