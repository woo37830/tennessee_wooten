#!/bin/bash
#
#  Convert line endings from Windooze to Unix
#
if [[ $# -ne 2 ]]; then
	echo "Useage: ToUnix.sh bad_file > good_file"
	exit
fi
sed -e "s/\r//g" $1  > $2
echo "All Done!"
