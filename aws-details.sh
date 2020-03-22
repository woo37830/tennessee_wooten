#!/bin/bash
#
# List the  json_data from the logs table for a given id
#
if [[ ${#} = 0 ]]; then 
   echo "Usage: ${0}  db-password id";
   exit;
fi
echo "json_data for id ${2}"
mysql -uwoo -p${1} -D users_db -h 44.231.61.194 -B -N -e "select request_json from logs where id = ${2}" | python -m json.tool
echo 'All Done!'


