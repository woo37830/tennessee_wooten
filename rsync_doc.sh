#!/bin/bash
/usr/bin/rsync -avt --log-file=/Users/woo/backups/rsync/backup.log  /Users/woo/Development/workspaces/archiver/archiverDoc/tex/*.pdf woo@barsoom:/Library/Tomcat/webapps/freemind/
/usr/bin/rsync -avt --log-file=/Users/woo/backups/rsync/backup.log  /Users/woo/Development/workspaces/archiver/archiverDoc/html/*.html woo@barsoom:/Library/Tomcat/webapps/freemind/
/usr/bin/rsync -avt --log-file=/Users/woo/backups/rsync/backup.log /Users/woo/Development/workspaces/archiver/archiverDoc/html/Tests.html woo@barsoom:/Library/Tomcat/webapps/freemind/
echo All Done!
