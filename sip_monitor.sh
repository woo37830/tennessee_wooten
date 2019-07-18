#!/usr/bin/env bash
#br="$(tput -S <<<$'setaf 1\nbold\n')" # Bold Red
br="\033[1;31m";
#bg="$(tput -S <<<$'setaf 2\nbold\n')" # Bold Green
bg="\033[1;32m";
#ar="$(tput sgr0)" # Text attributes reset
ar="\033[0m ";
#
# Monitor the status of the System Integrity Protection (SIP)
#
#printf "`csrutil status | grep --color 'disabled'`\n";
if  csrutil status | grep 'disabled' &> /dev/null; then
printf "System Integrity Protection status: ${br}disabled${ar}\n";
else
printf "System Integrity Protection status: ${bg}enabled${ar}\n";
fi
