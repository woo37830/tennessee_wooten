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

echo "Running ~/backup_db" >> /Users/woo/logs/daily.out
/Users/woo/bin/backup_db

time_machine_log=/Users/woo/logs/time_machine.log
if [ -e "$time_machine_log" ]; then
  chmod -R 755 /Users/woo/backups
  echo "Trimming time_machine log at $time_machine_log" >> /Users/woo/logs/$time_machine_log
  echo "$(tail -n 50 $time_machine_log)" >> /Users/woo/logs/$time_machine_log
fi
rsync_log=/Users/woo/logs/rsync.log
if [ -e "$rsync_log" ]; then
  chmod -R 755 /Users/woo/backups
  echo "Trimming rsync_log at $rsync_log" >> /Usere/woo/logs/daily.out
  echo "$(tail -n 50 $rsync_log)" > $rsync_log
fi
echo "All done with daily_tasks.sh"
