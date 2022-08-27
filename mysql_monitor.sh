#!/bin/bash
#br="$(tput -S <<<$'setaf 1\nbold\n')" # Bold Red
br="\033[1;31m";
#bg="$(tput -S <<<$'setaf 2\nbold\n')" # Bold Green
bg="\033[1;32m";
#ar="$(tput sgr0)" # Text attributes reset
ar="\033[0m ";
FILE=/usr/local/mysql/bin/mysqld
APP=MySQL
if [ -e $FILE ]; then
UP=$(pgrep mysqld | wc -l);
  if [ $UP != 1 ];
    then
       printf "${APP} is ${br}not running.${ar}\n";
    else
       printf "${APP} is ${bg}running.${ar}\n";
  fi
else
  printf "${APP} is ${bg}not available.${ar}\n";
fi
