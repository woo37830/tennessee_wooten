#!/bin/bash
#
# Description: return cpu;mem;dsk usage as a string
#
myCpu=`/Users/woo/bin/stat_cpu.sh`
myMem=`/Users/woo/bin/stat_mem.sh`
myDsk=`/Users/woo/bin/stat_dsk.sh`
echo "$myCpu;$myMem;$myDsk"
