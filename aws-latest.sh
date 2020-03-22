#!/bin/bash
#
# List the latest users added to the aws database users_db
# List the latest log entries
#
if [[ ${#} = 0 ]]; then 
   echo "Usage: ${0} db-password";
   exit;
fi
echo 'Latest users'
mysql -uwoo -p${1} -D users_db -h 44.231.61.194 -B -N -e "select * from users order by id desc limit 5"
echo 'Last logs'
mysql -uwoo -p${1} -D users_db -h 44.231.61.194 -B -N -e "select id, received, email, status from logs order by id desc limit 5"
echo 'All Done!'


