#!/bin/sh

# USAGE: rssreader.sh [number of entries you want to see] [url of rss feed]

# max length of each block of output
mymaxlength=250

# Modified From: http://thememymac.com/2009/geektool/geektool-all-the-scripts-i-could-find-explained-for-beginners/
# Script info can be found here: http://www.askdavetaylor.com/can_i_track_an_rss_feed_with_a_shell_script.html

# LIST OF NEWS RSS: http://news.yahoo.com/rss 

if [ $# -ne 2 ] ; then
  echo "Usage: rssreadertitle.sh [number of entries to return] [url]"
  exit 0
fi

headarg="-$(( $1 ))"
myurl=$2

# feedads was breaking the reading of slashdot - they've got a carriage return and then this in their <description>
curl --silent "$myurl" | grep -E '(title>)' | \
  grep -v "feedads" | \
  sed -n '4,$p' | \
  sed -e 's/<title>//' -e 's/<\/title>//' | \
  sed -e 's/<!\[CDATA\[//g' |            
  sed -e 's/\]\]>//g' |         
  sed -e 's/<[^>]*>//g' |      
  head $headarg | awk -v mylength=$mymaxlength {'print substr($0,0,mylength)'} | sed G | sed -e 's/^\ *//' | sed -e '/^$/d'

echo
#EOF
