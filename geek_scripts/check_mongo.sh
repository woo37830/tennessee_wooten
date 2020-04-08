#!/bin/bash
#
# Check if mongodb is running
#
FILE=/usr/local/bin/mongod
APP=MongoDB
#br="$(tput -S <<<$'setaf 1\nbold\n')" # Bold Red
br="\033[1;31m";
#bg="$(tput -S <<<$'setaf 2\nbold\n')" # Bold Green
bg="\033[1;32m";
#ar="$(tput sgr0)" # Text attributes reset
ar="\033[0m ";

if [ -e $FILE ] ; then

psql -l > /dev/null 2>&1
  if [[ $? -ne 0 ]] ; then
    printf "${APP} is ${br}not running.${ar}\n"
  else
    printf "${APP} ${bg}is running.${ar}\n"
  fi
else
  printf "${APP} ${br}is not available.${ar}\n"
fi
