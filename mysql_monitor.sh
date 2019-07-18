#!/bin/bash
UP=$(pgrep mysqld | wc -l);
if [ $UP != 1 ];
then
   printf "MYSQL is \033[1;31mdown.\033[0m\n";
else
   printf "MySQL is \033[32mrunning.\033[0m\n";
fi
#printf "`csrutil status | grep --color 'disabled'`\n";
if  csrutil status | grep 'disabled' &> /dev/null; then
printf "System Integrity Protection status: \033[1;31mdisabled\033[0m\n";
else
printf "System Integrity Protection status: \033[32menabled\033[0m\n";
fi
source ~/bin/check_docker.sh
