#!/bin/bash

# "Requires Lynx. http://www.apple.com/downloads/macosx/unix_open_source/lynxtextwebbrowser.html"

# Replace with the zipcode for the weather you want.
myzipcode=$1

myurl="http://printer.wunderground.com/cgi-bin/findweather/getForecast?query="$myzipcode
myweathercommand="lynx -dump "$myurl
myweatherresults=`$myweathercommand`

# uncomment for testing:
#echo $myweatherresults

echo "Weather for: $myzipcode"

# Temperature
echo $myweatherresults | awk '{start=index($0,"Temperature");end=index($0,"Humidity");start=start+12;end=end-4;print "  " substr($0,start,end-start), substr($0,end+2,1)}'
# original version - this does 2 web calls, where the other way does 1
#echo `$myweathercommand | awk '/Temp/{printf $2, ": "; for (i=3; i<=3; i++) printf $i " " }'`
# new way is also more kind to website changes.

# Forecast
# this should be made more efficient by someone who knows regexp/awk better
echo $myweatherresults | awk '{start=index($0,"Conditions");str=substr($0,start+10,length($0)-start-10);start=index(str,"Conditions");end=index(str,"Visibility");start=start+11;print "  " substr(str,start,end-start)}'
# original version - this does 2 web calls, where the other way does 1
# new way is also more kind to website changes.
#echo `$myweathercommand | awk '/Cond/ && !/Fore/ {for (i=2; i<=10; i++) printf $i " " }'`

echo
