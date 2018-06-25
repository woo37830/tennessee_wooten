#!/bin/sh

# USAGE: rssreader.sh [number of entries you want to see] [url of rss feed]

# max length of each block of output
mymaxlength=250

# Modified From: http://thememymac.com/2009/geektool/geektool-all-the-scripts-i-could-find-explained-for-beginners/
# Script info can be found here: http://www.askdavetaylor.com/can_i_track_an_rss_feed_with_a_shell_script.html

# LIST OF NEWS RSS: http://news.yahoo.com/rss 

if [ $# -ne 2 ] ; then
  echo "Usage: rssreader.sh [number of entries to return] [url]"
  exit 0
fi

# multiply by 2 so you get title and description for each entry
headarg="-$(( $1 * 2 ))"
myurl=$2

#if [ $# -eq 1 ] ; then
  #headarg=$(( $1 * 2 ))
#else
  #headarg="-8"
#fi

# feedads was breaking the reading of slashdot - they've got a carriage return and then this in their <description>
curl --silent "$myurl" | grep -E '(title>|description>)' | \
  grep -v "feedads" | \
  sed -n '4,$p' | \
  sed -e 's/<title>//' -e 's/<\/title>//' -e 's/<description>/   /' \
      -e 's/<\/description>//' | \
  sed -e 's/<!\[CDATA\[//g' |            
  sed -e 's/\]\]>//g' |         
  sed -e 's/<[^>]*>//g' |      
  head $headarg | awk -v mylength=$mymaxlength {'print substr($0,0,mylength)'} | sed G | fmt
