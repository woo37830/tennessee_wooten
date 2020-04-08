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
#
# Show last backup
echo "Latest: `tmutil latestbackup | awk -F'/' '{print $6}'`"
###############################################################################################################
#
# END OF SCRIPT

# let the script rerun by removing the temporary file
if [ -e $myscriptpath/.$mynameofscript.txt ] ; then
rm -rf $myscriptpath/.$mynameofscript.txt
fi

#EOF
