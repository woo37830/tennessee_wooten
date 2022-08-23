#!/bin/bash

###############################################################################################################
#
# ABOUT

# Theresa L. Ford, 2009
# T@Cattail.Nu
# http://www.cattail.nu/
# Current script collection and commentary: http://www.cattail.nu/mac/GeekTool/index.html

###############################################################################################################
#
# DIRECTIONS

# 1. Modify the "myscriptpath" variable below if scripts are not in the same place as main.bash.
# 2. Put a # at the beginning of any line you don't want to run (comment it out).
#    Remove the # at the beginning of any line you want to run (uncomment it).
# 3. Put main.bash in your GeekTool shell command line (you will have to include your entire path to the file).


###############################################################################################################
#
# NOTES

# 1. Scripts must be executable (in the script directory):  chmod +x *.sh *.bash icalevents
# 2. Scripts must be able to write to the current directory.  (By default, they're yours and you run them, so
#    should work by default.)
# 3. It is possible for the output of this script to be too long for the GeekTool geeklet (window),
#    so you might want to copy this script and let different lines run in each, and make geeklets for each copy.
# 4. To run scripts individually in GeekTool, just provide the full folder path to the script wherever you
#    see $myscriptpath.
# 5. The more things that are included, the longer it takes for the script to execute, particularly when
#    you add internet things.  Set your refresh rate in GeekTool appropriately.

###############################################################################################################
#
# myscriptpath

# Where did you unzip these scripts to?
myscriptpath="/Users/woo/bin/geek_scripts"
# OR use this, which finds this script and guesses you put them all here.
# location of this script:
#myscriptpath=`echo $0 | rev | awk '{firstslash=index($0,"/");print substr($0,firstslash+1,length($0)); }' | rev`

###############################################################################################################
#
# START OF SCRIPT

# Check to see if the script has finished before running it again.
# This keeps your system from eating too many resources.
# Don't modify.  The file is removed again at the end of this script.

mynameofscript=`echo $0 | rev | awk -F \/ '{print $1}'|rev`
if [ -e $myscriptpath/.$mynameofscript.txt ] ; then
  echo "Script is already running. Is your refresh rate too fast?"
  rm -rf $myscriptpath/.$mynameofscript.txt
  exit 0
fi
touch $myscriptpath/.$mynameofscript.txt

###############################################################################################################
#
# CALENDAR SCRIPTS

# Today's date, formated: Wed  Oct 14 2009
# Left justified
#$myscriptpath/todaydate.bash
#date
# Centered over calendar
#echo "   `$myscriptpath/todaydate.bash`"

# The calendar with ## for the current day.
#$myscriptpath/calendar.bash

# The calendar, horizontal, with ## for the current day - uses calendar.bash
# Edit the script to use cal and have ||'s around the current day.
#$myscriptpath/calendarhorizontal.bash

# Your iCal events for Today and Tomorrow
# Note that ranged events may not be working correctly.
# icalevents command line program is required
#$myscriptpath/icaltodayevent.bash
#$myscriptpath/icaltomorrowevent.bash

#$myscriptpath/icalbuddy.bash
###############################################################################################################
#
# COMPUTER INFORMATION SCRIPTS

# Information about your computer.
$myscriptpath/computerinfo.bash
/bin/bash ~/bin/geek_scripts/check_docker.sh
/bin/bash ~/bin/geek_scripts/mysql_monitor.sh
/bin/bash ~/bin/geek_scripts/check_psql.sh
/bin/bash ~/bin/geek_scripts/check_mongo.sh
/bin/bash ~/bin/geek_scripts/sip_monitor.sh
if [ $HOSTNAME == "woo-pro.local" ]; then
	echo "Document root at: /usr/local/var/www"
elif  [ $HOSTNAME == "woo-va-air.local" ]; then
	echo "Document root at: /Library/WebServer/Documents"
elif [ $HOSTNAME == "xanadu.local" ]; then
	echo "Document root at: /opt/homebrew/var/www"
fi
#
# Show Current version - this is also in computerinfo.bash above amount of ram
# sw_vers | tail -2 | head -1
# Current uptime.
#echo "uptime: `uptime`"
$myscriptpath/niceuptime.bash

# What are my ip addresses?  Local and internet.
echo "IP Addresses"
$myscriptpath/ipaddress.bash
source $myscriptpath/external_address.bash
#
echo
du -sh ~/.Trash/ | awk '{print "Trash Size: " $1}'
echo
echo 'tell application "Mail" to return unread count of inbox as string & ""' | osascript | grep -v '0' | awk '{print "Unread Mail: " $1}'
###############################################################################################################
#
# END OF SCRIPT

# let the script rerun by removing the temporary file
if [ -e $myscriptpath/.$mynameofscript.txt ] ; then
rm -rf $myscriptpath/.$mynameofscript.txt
fi

#EOF
