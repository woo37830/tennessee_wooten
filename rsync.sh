#/bin/bash
#
# Definition: Create a backup copy of the cvsrep and databases
#             and copy them to xanadu/backups.
#             Then save the latest in backups/sql.
#
echo "Run at: $(date) by $(whoami)"
/usr/bin/rsync -avt --delete --exclude "*.DS_Store" --exclude ".fseventsd" --exclude ".Spotlight-V100" --exclude ".TemporaryItems" --exclude ".Trashes" --log-file=/Users/woo/backups/rsync/backup.log  /Users/woo/cvsrep woo@xanadu:backups/cvs

if [ ! -d /Users/woo/tmp/sql ]; then
  mkdir /Users/woo/tmp/sql
fi  
chown -R woo /Users/woo/tmp
chmod -R a+w /Users/woo/tmp
mysqldump -u root -prandom1 askjane_users_db > /Users/woo/tmp/sql/askjane_users_db.sql
mysqldump -u root -prandom1 blog_db > /Users/woo/tmp/sql/blog_db.sql
mysqldump -u root -prandom1 bugtracker > /Users/woo/tmp/sql/bugtracker.sql
mysqldump -u root -prandom1 mm_log > /Users/woo/tmp/sql/mm_log.sql
mysqldump -u root -prandom1 mm_prod > /Users/woo/tmp/sql/mm_prod.sql
mysqldump -u root -prandom1 mm_test_woo > /Users/woo/tmp/sql/mm_test_woo.sql
mysqldump -u root -prandom1 mm_test_rwm > /Users/woo/tmp/sql/mm_test_rwm.sql
mysqldump -u root -prandom1 queue_db > /Users/woo/tmp/sql/queue_db.sql
mysqldump -u root -prandom1 library > /Users/woo/tmp/sql/library.sql

if [ -s /Users/woo/tmp/sql/blog_db.sql ]; then
 /usr/bin/rsync -avt --delete --exclude "*.DS_Store" --exclude ".fseventsd" --exclude ".Spotlight-V100" --exclude ".TemporaryItems" --exclude ".Trashes" --log-file=/Users/woo/backups/rsync/sql.log /Users/woo/tmp/sql/ woo@xanadu:backups/sql

 rm -rf /Users/woo/backups/sql
 mv /Users/woo/tmp/sql /Users/woo/backups
else
  echo "sql files had zero lenth and were not replaced in backups/sql or on xanadu"
fi  
echo "All Done!"
