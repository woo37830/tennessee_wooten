#!/bin/bash
# http://thememymac.com/2009/geektool/geektool-all-the-scripts-i-could-find-explained-for-beginners/
echo 'tell application "Mail" to return unread count of inbox as string & ""' | osascript | grep -v '0' | awk '{print "Unread Mail: " $1}'
