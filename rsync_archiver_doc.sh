#!/bin/bash
#
# This syncs the doc files from a workspace to barsoom web server
#
# We should check if they are on this server
#
if [ -e /Users/woo/Development/workspaces/archiver/archiverDoc ]
then
/usr/bin/rsync -avt --log-file=/Users/woo/backups/rsync/backup.log  /Users/woo/Development/workspaces/archiver/archiverDoc/tex/*.pdf woo@barsoom:/Library/Tomcat/webapps/freemind/
/usr/bin/rsync -avt --log-file=/Users/woo/backups/rsync/backup.log  /Users/woo/Development/workspaces/archiver/archiverDoc/html/*.html woo@barsoom:/Library/Tomcat/webapps/freemind/
/usr/bin/rsync -avt --log-file=/Users/woo/backups/rsync/backup.log /Users/woo/Development/workspaces/archiver/archiverDoc/html/Tests.html woo@barsoom:/Library/Tomcat/webapps/freemind/
else
   echo "This host does not appear to have the archiver docs"
   exit
fi
echo All Done!
