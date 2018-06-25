#!/bin/bash
#
#  This script takes a set of FILES below and syncs them from the host
#  to the BACKUP_HOST into the home directory (DESTDIR).  If the FILES
#  come from the same directory as the DESTDIR, then it is a sync operation.
#  If not, the the files are synced with what is in the DESTDIR which might
#  be a backup directory.
#
BACKUP_HOST="woo@barsoom.local"
LOGFILE="tmp/rsync.log"

# --verbose  --progress --stats

RSYNC_CMD="/usr/bin/rsync --compress --recursive --times --perms --links --delete --log-file=${LOGFILE}"

REMOTE_CMD="/usr/bin/ssh"

DESTDIR="."

FILES="bin
.alias
.bash_profile
pers
data"

/bin/date

for f in $FILES
do
echo
echo "running $f sync, destination: $BACKUP_HOST"
$RSYNC_CMD -e "${REMOTE_CMD}" --exclude "*.bak" --exclude "*~" $f ${BACKUP_HOST}:$DESTDIR
done
