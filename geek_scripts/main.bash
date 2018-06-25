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

#mynameofscript=`echo $0 | rev | awk -F \/ '{print $1}'|rev`
#if [ -e $myscriptpath/.$mynameofscript.txt ] ; then
#  echo "Script is already running. Is your refresh rate too fast?"
#  rm -rf $myscriptpath/.$mynameofscript.txt
#  exit 0
#fi
#touch $myscriptpath/.$mynameofscript.txt

###############################################################################################################
#
# CALENDAR SCRIPTS

# Today's date, formated: Wed  Oct 14 2009
# Left justified
#$myscriptpath/todaydate.bash
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
#$myscriptpath/computerinfo.bash

# Current uptime.
#echo "uptime: `uptime`"
#echo
#$myscriptpath/niceuptime.bash

# Show hard drive usage and free space.
$myscriptpath/diskspace.bash

# What processes are using up your cpu?
# If this script isn't working, read it and update it.
# processesbycpu.bash [number of processes to display]
#$myscriptpath/processesbycpu.bash 3

# What processes are using up your memory?
# If this script isn't working, read it and update it.
# processesbymem.bash [number of processes to display]
#$myscriptpath/processesbymem.bash 3

# How charged is my battery?
#$myscriptpath/battery.bash

# What is my current screen resolution?
# Modify the script for a less or more verbose output.
#$myscriptpath/screenresolution.bash

# What is my .Trash size?
$myscriptpath/trashsize.bash

# What is currently playing in iTunes?
#$myscriptpath/nowplayinginitunes.bash

# What are my ip addresses?  Local and internet.
echo "IP Addresses"
$myscriptpath/ipaddress.bash

###############################################################################################################
#
# NETWORK AND INTERNET SCRIPTS

# checks for the internet connection and creates a NOINTERNET variable
# source this so the NOINTERNET environment variable arrives.
# if you comment this out, the internet required scripts wont run.
# if you are running the scripts individually, you don't need to worry about this.
source $myscriptpath/internetcheck.bash

# put all scripts that need internet inside this if/fi
# as there is no point in running them if you have no internet
# if you are running the scripts individually, you don't need to worry about this.
if [ "$NOINTERNET" -eq "2" ]; then

  #############################################################################################################
  #
  # Miscellaneous Internet

  # What is my network activity? kb/s
  # Adds a 3 second wait for resampling.
  #$myscriptpath/networkactivity.sh

  # What is my Airport signal strength?
  #$myscriptpath/airport.sh

  # Is my server up?
  # give servercheck.bash a server to ping
  $myscriptpath/servercheck.bash jwooten37830.com
  #$myscriptpath/servercheck.bash anguish.org
  #$myscriptpath/servercheck.bash google.com
  echo

  # What's the weather?
  # You can modify this script to show Temperature and/or Conditions
  # give weather.bash a zipcode
  #$myscriptpath/weather.bash 20653
  #$myscriptpath/weather.bash 22202 

  # Do I have unread IMs in Adium?
  #$myscriptpath/adium.bash $myscriptpath

  # What is today's NASDAQ for Stock Symbol
  # stock.bash [symbol]
  # Apple is AAPL
  #$myscriptpath/stock.bash AAPL

  #############################################################################################################
  #
  # RSS Reader

  # RSS Reader / RSS Reader Title Only
  # rssreader.sh [number of entries you want displayed] [url]
  # rssreadertitle.sh [number of entries you want displayed] [url]
  # Note that rssreader.sh has a configurable max length of characters in its script.

  # Slashdot RSS
  #$myscriptpath/rssreader.sh 2 http://rss.slashdot.org/Slashdot/slashdot
  #$myscriptpath/rssreadertitle.sh 8 http://rss.slashdot.org/Slashdot/slashdot

  # LIST OF NEWS RSS FEEDS can be found here: http://news.yahoo.com/rss
  # Canada news top stories RSS
  #$myscriptpath/rssreader.sh 2 http://ca.rss.news.yahoo.com/rss/topstories
  #$myscriptpath/rssreadertitle.sh 8 http://ca.rss.news.yahoo.com/rss/topstories

  # Today's showtime schedule RSS
  # LIST OF NEWS RSS FEEDS can be found here: http://www.sho.com/site/rss.do
  #$myscriptpath/rssreader.sh 2 http://www.sho.com/site/schedules/rss.do?schedule=daily&channel=SHO
  #$myscriptpath/rssreadertitle.sh 8 http://www.sho.com/site/schedules/rss.do?schedule=daily&channel=SHO

  # Ancient Anguish Adventurer's Board
  #$myscriptpath/rssreadertitle.sh 8 http://anguish.org/rss/class.adv.xml | awk '{ split($0,str,"http"); print str[1];'}

  # mytvrss.com Reader (different from the other reader due to custom html stripping)
  # rssmytvrss.sh [number of entries] [0 for today onwards, 1 for all] [url]
  #$myscriptpath/rssmytvrss.sh 5 0 http://www.mytvrss.com/tvrss.xml?id=353762

  #############################################################################################################
  #
  # Sniffer

  # Network Traffic Sniffer
  # sniffer.bash [interface] [max packets] [timeout]
  # Read the script, if you don't have tcpdump, don't bother with this.
  #$myscriptpath/sniffer.bash ppp0 3 10
  #$myscriptpath/sniffer.bash en3 3 10

fi

###############################################################################################################
#
# DEVELOPMENT - These need some work yet.

# Recently modified files - this takes a while to run.
#echo Recently modified
#$myscriptpath/recent.bash

# How many unread mail do I have?
#echo Unread mail
$myscriptpath/unreadmail.bash

###############################################################################################################
#
# END OF SCRIPT

# let the script rerun by removing the temporary file
if [ -e $myscriptpath/.$mynameofscript.txt ] ; then
rm -rf $myscriptpath/.$mynameofscript.txt
fi

#EOF
