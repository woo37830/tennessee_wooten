#!/bin/bash
#
# Description: Calculate Used Memory Percentage
#
myUsedMem=`top -l 1 | grep -E '^Phys' |  awk '{print $2}' | sed s/G// `
#echo "usedMem: $myUsedMem"
if [[ $myUsedMem =~ .*M.* ]]
then
   myUsedMem=`echo $myUsedMem|awk -F'M' '{print $1}'`
   else
   myUsedMem=`echo|awk '{print f * 1024}' f=$myUsedMem`
fi
#echo "usedMem: $myUsedMem"
myFreeMem=`top -l 1 | grep -E '^Phys' |  awk '{print $6}' | sed s/M// `
#echo "freeMem: $myFreeMem"
myUsedPer=`echo |awk '{print u/ (u+f) * 100}' u=$myUsedMem f=$myFreeMem`
myUsedPer=`echo $myUsedPer | awk -F'.' '{print $1}'`
echo "$myUsedPer"
