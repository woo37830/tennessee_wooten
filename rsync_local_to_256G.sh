#!/bin/bash
#
# Check that the external drive is mounted
#
drive=Exteranl_256G
if mount | grep "/$drive" > /dev/null; then
# If not running as root ( i.e. sudo, inform and quit )
# Run the rsync template using the list of files in rsync_files.txt
# Syncing to External_256G and logging there.
# ( 20161203 )
#
if [ "$(id -u)" != "0" ]; then
    echo "Sorry, you are not root."
    exit 1
fi

while IFS= read -r opt; do
  rsync_local_template.sh $opt  # (i.e. do action / processing of $databaseName
done <~woo/bin/rsync_files.txt


date +'%c|Backup ended'   >> /Volumes/External_256G/sync.log
else
    echo "The drive $drive is not mounted"
fi
echo All Done!
