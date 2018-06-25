#!/bin/sh
SOURCE_DIRS="cvsrep:Development:Documents:lib:Music:PC_Share:Pictures:Library/Mail"
TARGET_DIR="/Volumes/LaCie Drive/Backups/061117"

# if the external drive is not there, complain and stop
if [ ! -e "$TARGET_DIR" ]
then
  echo Target directory does not exist!
  exit
fi

IFS=:

pushd .
cd ~/
/usr/bin/rsync -E --delete --progress -av $SOURCE_DIRS "$TARGET_DIR"
popd