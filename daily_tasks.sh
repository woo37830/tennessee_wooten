#!/bin/sh
echo "Running from: " && echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Logs go to /var/log/daily.out"

rm -f /Users/woo/.freemind/log.*
rm -f /Users/woo/.freemind/*.mm
rm -f /Users/woo/Development/workspaces/freemind/*.log.*
rm -f /Users/woo/Development/workspaces/freemind/*.log
rm -f /Users/woo/Desktop/*.log
rm -f /Applications/NetBeans/glassfish-3.1.2.2/glassfish/domains/domain1/logs/server.*

echo "Starting to unlock locked files"
chflags -R nouchg /Users/woo/
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

echo "All done with daily_tasks.sh"
