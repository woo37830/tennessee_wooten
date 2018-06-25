#!/bin/bash
# 2 formats, uncomment the one you want

# Used: 48Gi/56Gi 88% Available: 7.1Gi
#df -h | grep disk | awk '{ print "Used: " $3 "/" $2 " " $5 " Available: " $4 }'

# http://www.ryanlineker.com/geektool-scripts/
# 7.1gb free (56gb)
myoutput=`df -hl | grep 'disk' | awk '{print $4 " free " "("$2")"}' | sed s/Gi/gb/g`

echo "Disk Space: $myoutput"
echo
