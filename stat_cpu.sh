#!/bin/bash
#
# Description: Calculate cpu usage
#
top -l 1 | awk '/CPU usage/ {print $3}' | awk -F'.' '{print $1}' | sed s/%//

