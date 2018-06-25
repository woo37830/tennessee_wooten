#!/bin/bash
# http://thememymac.com/2009/geektool/geektool-all-the-scripts-i-could-find-explained-for-beginners/
du -sh ~/.Trash/ | awk '{print "Trash Size: " $1}'
echo
