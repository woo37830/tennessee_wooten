myCPU=`top -l 1 | awk '/CPU usage/ {print $3}' | sed s/%//`
myCPU=`echo "tmp=$myCPU; tmp /= 1; tmp" | bc`

typeset -i b=9
echo -e "CPU Usage    \c"
while [ $b -lt $myCPU ]
do
	echo -e "\033[1;36m*\033[0m\c"
	b=`expr $b + 10`
done
echo -e "\033[1;39m*\033[0m\c"
while [ $b -lt 99 ]
do
	echo -e "\033[1;37m*\033[0m\c"

	b=`expr $b + 10`
done
echo -e "	$myCPU%\c"

echo -e "\r"
unset myCPU
unset b


#myUsedMem=`top -l 1 | awk '/PhysMem/ {print $8}' | sed s/M// `
#myFreeMem=`top -l 1 | awk '/PhysMem/ {print $10}' | sed s/M// `
#myActiveMem=`top -l 1 | awk '/PhysMem/ {print $4}' | sed s/M// `
#myTotalMem=` expr $myUsedMem + $myFreeMem`
#myUsedPer=`echo |awk '{print f / t * 100}' f=$myActiveMem t=$myTotalMem`
#myUsedPer=`echo "tmp=$myUsedPer; tmp /= 1; tmp" | bc`
#myUsedPer=`echo $myUsedPer | sed 's/,/./g'`
myUsedPer=`~/bin/memory.sh`

typeset -i c=9
echo -e "Memory Usage \c"
while [ $c -lt $myUsedPer ]
do
        echo -e "\033[1;36m*\033[0m\c"
        c=`expr $c + 10`
done

echo -e "\033[1;39m*\033[0m\c"
while [ $c -lt 99 ]
do
        echo -e "\033[1;37m*\033[0m\c"
        c=`expr $c + 10`
done
echo -e "	$myUsedPer%\c"

echo -e "\r"

unset myUsedMem
unset myFreeMem
unset myTotalMem
unset myUsedPer
unset c


mDisk=`df | awk '/dev\/disk1s2/ && NF>1 {print $5}' | sed 's/\%//'`

#while [ $mDisk ]
#do
myDisk=`expr 100 - $mDisk `

typeset -i a=9
echo -e "Disk Usage   \c"
while [ $a -lt 100 ]
do
	echo -e "\033[1;36m*\033[0m\c"
	a=`expr $a + 10`
done
echo -e "\033[1;39m*\033[0m\c"
while [ $a -lt 99 ]
do
	echo -e "\033[1;37m*\033[0m\c"
	a=`expr $a + 10`
done
echo -e "	$myDisk%\c"

echo -e "\r"
unset myDisk
unset mDisk
unset a
#done
