if [ -e /var/backup/db/daily ]; then
echo "daily"
ls -al /var/backup/db/daily/mm_prod | grep -E 'daily' | awk '{print $9}'
echo "weekly"
ls -al /var/backup/db/weekly/mm_prod | grep -E 'weekly' | awk '{print $9}'
echo "monthly"
ls -al /var/backup/db/monthly/mm_prod | grep -E 'monthly' | awk '{print $9}'
else
    echo "backups not present"
fi
echo "All Done!"
