#!/bin/bash

# USAGE: sniffer.bash [interface] [maxpackets] [timeout]
# Requires: timeout.bash

# This requires tcpdump to be installed, which probably needs libpcap (or equivalent)
# - go read the mac tcpdump installation documentation
# - and then go read how tcpdump works
# - and then go learn what the output actually means
# (it's a competency test to see if you are smart enough to be granted 
# the privilege of sniffing, as near as I can tell).
# Hint: Look up wireshark.
# Don't run a sniffer on your work network without permission.

if [ $# -ne 3 ] ; then
  echo "Usage: sniffer.bash [interface] [maxpackets] [timeout]"
  exit 0
fi

# And then set a timeout so your GeekTools don't hang (in seconds).
mytimeout=$3

# and then set a max number of packets to capture
mymaxpackets=$2

# listen on what?
myinterface=$1

# Feel free to modify this to suit your needs.  man tcpdump
mytcpdumpcommand="tcpdump -vv -A -tttt -n -K -c $mymaxpackets -i $myinterface"
#echo $mytcpdumpcommand

myscriptpath=`echo $0 | rev | awk '{firstslash=index($0,"/");print substr($0,firstslash+1,length($0)); }' | rev`

#the timeout.bash is used to kill the tcpdump process if it isn't getting any packets
myscripttimeout=$myscriptpath"/timeout.bash"

# if you want promisc mode, you're going to have to turn it on
# if you don't know what promisc means or how it affects what you see, you skipped the directions at the beginning of
# this file.
# you're going to have to find out how geektool deals with sudo, too.
# You can get an ifconfig that has promisc here: http://www.stanford.edu/~dub/macstuff/index.html
# I have no idea if it's "clean".
# sudo $myscriptpath/ifconfig $myinterface promisc

$myscripttimeout -t $mytimeout $mytcpdumpcommand

# generally not wise to leave promisc mode going.
# sudo $myscriptpath/ifconfig $myinterface -promisc

echo
