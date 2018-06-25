#!/bin/sh

# Theresa L. Ford, 2/2010, www.Cattail.Nu

# This is expecting an mytvrss.com xml like:
# http://www.mytvrss.com/tvrss.xml?id=353762

# If it is not returning anything, there may be no events that match your date, try 1 as the second argument.

# USAGE: rssmytvrss.sh [number of entries you want to see] [0 for today onwards, 1 for all] [url of rss feed]

# max length of each block of output
mymaxlength=250

if [ $# -ne 3 ] ; then
  echo "Usage: rssmytvrss.sh [number of entries to return] [0 for today onwards, 1 for all] [url]"
  exit 0
fi

headarg="-$1"
myall=$2
myurl=$3

mytoday=`date +%Y%m%d`

curl --silent "$myurl" | \
  grep -E '(title>|description>)' | \
  sed -e 's/<title>//' -e 's/<\/title>//' -e 's/<description>/   /' | \
  sed 's/&lt;/</g' | \
  sed 's/&gt;/>/g' | \
  sed 's/<p>//g' | \
  sed 's/<\/p>/~/g' | \
  sed -e 's/.*Air date: //' | \
  sed 's/<a href.*//' | \
  sed 's/      //' | \
  sed '1!G;h;$!d' | \
  paste -d' ' - - | \
  sed 's/~ /~/' | \
  sed 's/\//~/' | \
  sed 's/\//~/' | \
  grep -v mytvrss | \
  awk -v myall=$myall -v mytoday=$mytoday -F'~' '{ a=( $3 $1 $2 ); if ( myall+0==1 || a+0 >= mytoday+0 ) { print $3 "-" $1 "-" $2 ": " $4; } }' | \
  head $headarg | awk -v mylength=$mymaxlength {'print substr($0,0,mylength)'} 

#EOF
