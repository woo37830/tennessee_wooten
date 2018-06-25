/usr/bin/rsync -az  --delete --log-file=/Users/woo/backups/rsync/backup.log  $1 /Volumes/External_256G/$1
echo "$1 completed."
