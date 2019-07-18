#!/usr/bin/env bash
#br="$(tput -S <<<$'setaf 1\nbold\n')" # Bold Red
br="\033[1;31m";
#bg="$(tput -S <<<$'setaf 2\nbold\n')" # Bold Green
bg="\033[1;32m";
#ar="$(tput sgr0)" # Text attributes reset
ar="\033[0m ";

UP=$(pgrep mysqld | wc -l);
if [ $UP != 1 ];
then
   printf "MYSQL is ${br}down.${ar}\n";
else
   printf "MySQL is ${bg}running.${ar}\n";
fi
