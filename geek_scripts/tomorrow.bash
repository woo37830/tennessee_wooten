#!/bin/bash

#  tomorrow.bash
#
# Prints tomorrow's events using icalBuddy
#
#  Created by John Wooten on 11/3/13.
#

day_in_seconds=86400
two_days_in_seconds=172800

# get current seconds since the epoch
sec=`date +%s`

# get tomorrows date as seconds since the epoch
sec_tomorrow=`expr ${sec} + ${day_in_seconds}`
sec_day_after_tomorrow=`expr ${sec} + ${two_days_in_seconds}`

# 'start' date/time, in the format required by icalBuddy
start_dt="`date -r ${sec_tomorrow} +'%Y-%m-%d 00:00:00 %z'`"

# 'end' date/time, in the format required by icalBuddy
end_dt="`date -r ${sec_day_after_tomorrow} +'%Y-%m-%d 23:59:59 %z'`"

#/usr/local/bin/icalBuddy -f -sd -eep * -df "%a, %b %e" -ec Automator #eventsFrom:"${start_dt}" to:"${end_dt}"

#/usr/local/bin/icalBuddy eventsFrom:"${start_dt}" to:"${end_dt}"