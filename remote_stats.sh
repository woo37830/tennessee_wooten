myStats=`ssh barsoom stat_3.sh`
myCPU=`echo $myStats | awk -F';' '{print $1}'`
myCPU=`echo "tmp=$myCPU; tmp /= 1; tmp" | bc`

typeset -i b=9
echo "CPU Usage    \c"
while [ $b -lt $myCPU ]
do
	echo "\033[1;36m*\033[0m\c"
	b=`expr $b + 10`
done
echo "\033[1;39m*\033[0m\c"
while [ $b -lt 99 ]
do
	echo "\033[1;37m*\033[0m\c"

	b=`expr $b + 10`
done
echo "	$myCPU%\c"

echo "\r"
unset myCPU
unset b


myUsedPer=`echo $myStats | awk -F';'  '{print  $2}'`
myUsedPer=`echo "tmp=$myUsedPer; tmp /= 1; tmp" | bc`

typeset -i c=9
echo "Memory Usage \c"
while [ $c -lt $myUsedPer ]
do
        echo "\033[1;36m*\033[0m\c"
        c=`expr $c + 10`
done

echo "\033[1;39m*\033[0m\c"
while [ $c -lt 99 ]
do
        echo "\033[1;37m*\033[0m\c"
        c=`expr $c + 10`
done
echo "	$myUsedPer%\c"

echo "\r"

unset myUsedMem
unset myFreeMem
unset myTotalMem
unset myUsedPer
unset c


myDisk=`echo $myStats | awk -F';'  '{print $3}'`
myDisk=`expr 100 - $myDisk`

typeset -i a=9
echo "Disk Usage   \c"
while [ $a -lt $myDisk ]
do
	echo "\033[1;36m*\033[0m\c"
	a=`expr $a + 10`
done
echo "\033[1;39m*\033[0m\c"
while [ $a -lt 99 ]
do
	echo "\033[1;37m*\033[0m\c"
	a=`expr $a + 10`
done
echo "	$myDisk%\c"

echo "\r"
unset myDisk
unset a
