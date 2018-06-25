#!/bin/bash

# Usage:
# stock.bash AAPL
# Apple is AAPL

mysymbol="$1"
myurl="http://www.nasdaq.com/aspxcontent/NasdaqRSS.aspx?data=quotes&symbol=$1"

# get the results, strip html, leading spaces on lines, and &n's
myresults=`lynx -dump "$myurl" | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed -e 's/nbsp;/\n/g' | sed -e 's/^\ *//' | sed -e 's/&n/ /g' | sed -e "s/EDT/ EDT/g" ` 

# break it into fields
myresults=`echo "$myresults" | tr -d '\n' | sed -e 's/feedback\@nasdaq\.com/~/g' | sed -e 's/Last/~Last:/g' | sed -e 's/ Change/~Change: /g' | sed -e 's/%Change/~% Change:/g' | sed -e 's/Volume/~Volume:/g' | sed -e 's/As of/~As of/g' | sed -e "s/View/~View/g"`

# print the fields
echo $myresults | awk '{ split($0,str,"~"); print "NASDAQ: " str[2] "\n" str[3] "\n" str[4] "\n" str[5] "\n" str[6] "\na" str[7];}'
echo
