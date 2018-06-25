#!/bin/bash

# Modified from: http://macthemes2.net/forum/viewtopic.php?id=16793954&p=2

myscriptpath=`echo $0 | rev | awk '{firstslash=index($0,"/");print substr($0,firstslash+1,length($0)); }' | rev`

# uncomment this line to have just the basic calendar with ||'s around the current day and weeks mashed together
#cal | sed -e '1d' -e '2p;2p;2p;2p' | sed -e '$!N;s/\n/ /' -e '$!N;s/\n/ /' -e '$!N;s/\n/ /' -e '$!N;s/\n/ /' | sed "s/^/ /;s/$/ /;s/ $(date +%e) /\|$(date +%e)\|/"

# uncomment this line to have weeks split by a space and today's date replaced with a ##
$myscriptpath/calendar.bash | sed -e '1d' -e '2p;2p;2p;2p' | sed -e '$!N;s/\n/ /' -e '$!N;s/\n/ /' -e '$!N;s/\n/ /' -e '$!N;s/\n/ /' | sed "s/^/ /;s/$/ /;s/ $(date +%e) /\|$(date +%e)\|/" | sed -e "s/^\ \ //"

echo
