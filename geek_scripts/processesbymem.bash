#!/bin/bash

# Modified From: http://thememymac.com/2009/geektool/geektool-all-the-scripts-i-could-find-explained-for-beginners/

# max 20 lines
# default to 3 lines (title line + output lines)
if [ $# -ne 1 ] ; then
  mycount=4
else
  mycount=`echo $1+1 | bc`
fi

echo "Top Processes By Memory Usage:"

# uncomment this line to print a summary of usage
#top -orsize -F -R -l2 -n20 | grep 'CPU usage:' | tail -1

# if this script doesn't work, try putting a 0 in the following instead of a 1
# somewhere along the line apple updated top to give more info.
# it worked on my leopard install, but failed on my snow leopard install - this is the bad hack fix
if [ 1 ] ; then
	# this runs top twice (the first top includes this script in the output, and is therefore invalid)
	# then it chops off the first run (tail -21) along with the nice top header stuff (negating the grep in the else)
	# then it prints select columns from the top output 
	# and then limits the output to the number of lines you want (head $mycount)
	top -orsize -F -l2 -n20 | tail -21 | awk '{printf "%-8s %-15s %8s %8s %8s %8s %8s %8s %8s %8s %10s\n", $1, $2, $3, $8, $9, $10, $11, $12, $13, $16, $26}' | head -$mycount
else
	# this is from the original website cited at the top of the script
	top -orsize -F -R -l2 -n20 | grep '^....[1234567890] ' | grep -v ' 0.0% ..:' | cut -c 1-24,33-42,64-77 | head -$mycount
fi
echo
