#!/bin/bash

# http://www.ryanlineker.com/geektool-scripts/

scutil --get ComputerName;
sw_vers | awk -F':\t' '{print $2}' | paste -d ' ' - - - ;
sysctl -n hw.memsize | awk '{print $0/1073741824"gb RAM"}';
sysctl -n machdep.cpu.brand_string;

