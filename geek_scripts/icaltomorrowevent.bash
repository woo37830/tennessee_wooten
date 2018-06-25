#!/bin/bash

# Theresa L. Ford, http://www.cattail.nu, 2010
# Requires icalevents compiled command line program to be in the same directory

myscriptpath=`echo $0 | rev | awk '{firstslash=index($0,"/");print substr($0,firstslash+1,length($0)); }' | rev`

mytomorrow=`date +"%s"`
mytomorrow=$(( mytomorrow+60*60*24 ))
mytomorrow=`date -j -f "%s" $mytomorrow +"%Y-%m-%d"`

echo "Tomorrow's Events:"
$myscriptpath/icalevents | sort | grep -e "^$mytomorrow" | awk '{split($0,str,"~"); print str[1];}' | awk '{split($0,str," : "); print str[2];}'
echo

