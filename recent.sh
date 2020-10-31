#!/bin/bash
#
# Show the recent entries in the 'diary' which is
# the current years Journal_YYYY.txt file.
#
# This file is appened to when one does the diary command.
# and is searched by the search command.
#
echo "Recent";YYYY=`date +'%Y'`;tail -20 $NOTES_DIR/Journal_$YYYY.txt | grep "\S"
