#!/bin/bash
BACKUP_HOST="woo@xanadu.local"

REMOTE_CMD="/usr/bin/ssh"

TAR_CMD="/usr/bin/tar -cvPf - /Users/woo/bin | gzip"

TAR_SSH="${REMOTE_CMD} ${BACKUP_HOST}"

DESTDIR="backups/woo_laptop"

TARFILE_DIR="/Users/woo/${DESTDIR}"

/bin/date

echo "deleting old tar FS backups"
/usr/bin/ssh ${BACKUP_HOST}  \
/usr/bin/find ${TARFILE_DIR} -name '*.tar.gz' -and -mtime +7 | xargs rm -f 

BACKUP_FILE="/Users/woo/${DESTDIR}/tarfiles/bin-$(date +%Y_%m_%d).tar.gz"

echo "tar ~/bin backup starting"

$TAR_CMD | $TAR_SSH "cat - >${BACKUP_FILE}" 

