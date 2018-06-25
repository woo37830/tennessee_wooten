#!/bin/bash

# With "Screen Resolution:"
system_profiler 2>/dev/null | grep Resolution | sed -e "s/\ \ //g" | sed -e "s/Resol/Screen Resol/"

# Just the screen resolution.
#system_profiler 2>/dev/null | grep Resolution | sed -e "s/\ \ //g" | sed -e "s/Resolution:\ //"

echo

