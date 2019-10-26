#!/bin/bash
#
# Check if postgresql is running
#
FILE=/usr/local/bin/mongod
if [ -f $FILE ] ; then
#br="$(tput -S <<<$'setaf 1\nbold\n')" # Bold Red
br="\033[1;31m";
#bg="$(tput -S <<<$'setaf 2\nbold\n')" # Bold Green
bg="\033[1;32m";
#ar="$(tput sgr0)" # Text attributes reset
ar="\033[0m ";

pgrep mongod  > /dev/null 2>&1
if [[ $? -ne 0 ]] ; then
  printf "MongoDB is ${br}not running.${ar}\n"
  exit 1
fi
printf "MongoDB ${bg}is running.${ar}\n"
fi
