#!/bin/sh

# http://macthemes2.net/forum/viewtopic.php?id=16793954
# Displays total (upload and download) network usage across current active connection as KB/s.

# note that this adds a 3 second wait to your script as it resamples

enstatus() {
    # $NF = number of fields, so printing the last
    if [ $@ != "ppp0" ]; then
        ifconfig $@ 2>/dev/null | grep "status" | awk '{print $NF}';
    else
        ifconfig $@ 2>/dev/null | grep "netmask" | awk '{print $1}';
    fi
}

getbytes() {
    netstat -ib | awk "/$@/"'{print $7" "$10; exit}';
}

getstat() {
    waittime=3;
    sample1=(`getbytes $@`);
    sleep $waittime;
    sample2=(`getbytes $@`);
    results=(`echo "scale=2; ((${sample2[0]}+${sample2[1]})-(${sample1[0]}+${sample1[1]}))/(1024*$waittime)"| bc`);
    printf "Network: %.2f KB/s\n" ${results[0]};
}
#echo "`enstatus en0`"
#echo "`enstatus ppp0`"
#echo "`enstatus en1`"

if [ "`enstatus en0`" == "active" ]; then
    echo "`getstat en0`";
elif [ "`enstatus en1`" == "active" ]; then
    echo "`getstat en1`";
elif [ "`enstatus ppp0`" == "inet" ]; then
    echo "`getstat ppp0`";
else    
    echo "Offline";
fi
echo

#EOF
