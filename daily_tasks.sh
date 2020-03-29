#!/bin/sh
#
# These daily, weekly, and monthly maintenance scripts
# are involed from /etc/daily.local, weekly.local, and monthly.local
#
echo "Running from: " && echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Logs go to /var/log/daily.out"

rm -f /Users/woo/.freemind/log.*
rm -f /Users/woo/.freemind/*.mm
rm -f /Users/woo/Development/workspaces/freemind/*.log.*
rm -f /Users/woo/Development/workspaces/freemind/*.log
rm -f /Users/woo/Desktop/*.log
rm -f /Applications/NetBeans/glassfish-3.1.2.2/glassfish/domains/domain1/logs/server.*

echo "Starting to unlock locked files"
chflags -R nouchg /Users/woo
echo "Done with unlocking locked files!"
if [ -e '/usr/local/bin/automysqlbackup' ]
then
 echo 'doing automysqlbackup'
 /usr/local/bin/automysqlbackup /etc/automysqlbackup/myserver.conf
else
 echo '/usr/local/bin/automysqlbackup not found to do auto backup'
fi

if [ -e '/var/backup/db' ]
then
   chown -R root /var/backup/db
   chgrp -R wheel /var/backup/db
   chmod -R 755 /var/backup/db
fi
recover=/Users/woo/backups/aws
if [ -e "$recover" ]
then
   echo "Removing archives in $recover older than two weeks"
   find $recover/ -mindepth 1 -mtime +14 -exec rm '{}' \;
fi
time_machine_log=/Users/woo/backups/backups.log
if [ -e "$time_machine_log" ]; then
  chmod -R 755 /Users/woo/backups
  echo "Trimming time_machine log at $time_machine_log"
  echo "$(tail -n 50 $time_machine_log)" > $time_machine_log
fi
rsync_log=/Users/woo/backups/rsync.log
if [ -e "$rsync_log" ]; then
  chmod -R 755 /Users/woo/backups
  echo "Trimming rsync_log at $rsync_log"
  echo "$(tail -n 50 $rsync_log)" > $rsync_log
fi
echo "All done with daily_tasks.sh"
