#!/bin/bash
/usr/bin/rsync -avt --log-file=/Users/woo/backups/rsync/backup.log  /Users/woo/Dropbox/Personal/Documents/TeX/Documentation/*.pdf woo@barsoom:/Library/Server/Web/Data/Sites/Default/home/docs/
/usr/bin/rsync -avt --log-file=/Users/woo/backups/rsync/backup.log  /Users/woo/Dropbox/Personal/Documents/TeX/Documentation/code_docs.html woo@barsoom:/Library/Server/Web/Data/Sites/Default/home/
echo All Done!
