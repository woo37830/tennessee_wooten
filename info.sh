#!/bin/bash
echo "`top -l 1 | grep -E '^CPU' | awk '{print $1,$2,100-$7}'`"
echo "`top -l 1 | grep -E '^Phys' | awk '{print $1,$2,$3}'`"
echo "`df -h | grep -E '^/dev/disk1' | awk '{print $1, $5}'`"
echo "`df -h | grep -E '^/dev/disk2' | awk '{print $1, $5}'`"
echo "`df -h | grep -E '^/dev/disk3' | awk '{print $1, $5}'`"
sw_vers | tail -2 | head -1
echo "Latest: `tmutil latestbackup | awk -F'/' '{print $6}'`"
