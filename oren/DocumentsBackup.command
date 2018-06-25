#rotating backup script - v1.0
rm -rf "/Users/woo/Backup/DocumentsBackup.4"
mv -f "/Users/woo/Backup/DocumentsBackup.3" "/Users/woo/Backup/DocumentsBackup.4"
mv -f "/Users/woo/Backup/DocumentsBackup.2" "/Users/woo/Backup/DocumentsBackup.3"
mv -f "/Users/woo/Backup/DocumentsBackup.1" "/Users/woo/Backup/DocumentsBackup.2"
mv -f "/Users/woo/Backup/DocumentsBackup.0" "/Users/woo/Backup/DocumentsBackup.1"
time /usr/local/bin/rsync --rsync-path=/usr/local/bin/rsync -az --eahfs --showtogo --link-dest="/Users/woo/Backup/DocumentsBackup.1/" "/Users/woo/Documents" "/Users/woo/Backup/DocumentsBackup.0/"
