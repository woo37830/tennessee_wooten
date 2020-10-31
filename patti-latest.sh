#!/bin/bash
#
IP=ec2-44-241-140-144.us-west-2.compute.amazonaws.com
# List the latest users added to the aws database users_db
# List the latest log entries
#
if [[ $#  -eq 0 ]]; then 
   echo "Usage: ${0} db-password [lines]";
   exit;
fi
K=5
if [[ $# -eq  2 ]]; then
K=${2}
fi

echo "Latest $K users"
mysql -uwoo -p${1} -D users_db -h ec2-44-241-140-144.us-west-2.compute.amazonaws.com -B -N -e "select * from users order by id desc limit $K"
echo "Last $K logs"
mysql -uwoo -p${1} -D users_db -h $IP -B -N -e "select id, received, email, status, commit_hash, branch from logs order by id desc limit $K"
echo 'All Done!'


