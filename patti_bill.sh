#!/bin/bash
#
# Show the time charged to client for the current month
# TODO - add extract the month and year from date and use.
#                                                           
# Usage patti_bill.sh mon-num (1-12)
#
if [ $# != 1 ];
then
   echo "Usage: $0 mon-num (1-12)"
   exit
fi

~/bin/time_track_report.pl -client=patti -year=2020 -mon=$1
#
