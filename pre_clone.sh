#!/bin/sh
PATH="$PATH:/Applications/Server.app/Contents/ServerRoot/usr/bin"
PATH="$PATH:/Applications/Server.app/Contents/ServerRoot/usr/sbin"
PATH="$PATH:/Applications/Server.app/Contents/ServerRoot/usr/libexec"
export PATH

# Path to recovery directory (permissions should be 700 -- read-only root or admin)
recover="/etc/recover"
ts=`date ''+%F''`


echo "Removing manual archives older than two weeks"
find $recover/ -mindepth 1 -mtime +14 -exec rm '{}' \;

# mysqldump the databases
dbs="mm_prod askjane_users_db blog bugtracker queue queue_db"
for db in $dbs; do
   echo "Dumping $db"
   mysqldump --user=root --password='random1' $db > $recover/${db}_${ts}.dump
   gzip $recover/${db}_${ts}.dump
done

# If you ever need to restore from a database dump, you would run:
# gunzip $recover/database_name_(timestamp).dump.gz
# mysql -u root -p database_name < $recover/database_name.dump


# Backup Open Directory
day=`date ''+%u''`

od_backup=$recover/od_backup
echo "dirserv:backupArchiveParams:archivePassword = s3kr!t" > $od_backup
echo "dirserv:backupArchiveParams:archivePath = $recover/od_$ts" > $od_backup
echo "dirserv:command = backupArchive" > $od_backup

serveradmin command < $od_backup
