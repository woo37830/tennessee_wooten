#!/bin/bash
#
# Description: Calculate disk usage
#
df -h | grep -E '^/dev/disk1' | awk '{print $5}' | sed 's/\%//'
