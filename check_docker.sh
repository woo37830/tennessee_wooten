#!/bin/bash
#br="$(tput -S <<<$'setaf 1\nbold\n')" # Bold Red
br="\033[1;31m";
#bg="$(tput -S <<<$'setaf 2\nbold\n')" # Bold Green
bg="\033[1;32m";
#ar="$(tput sgr0)" # Text attributes reset
ar="\033[0m ";
#
# Check if docker is available and running
#
 ## will throw and error if the docker daemon is not running and jump
 ## to the next code chunk
 docker_state=$(docker info >/dev/null 2>&1)
 if [[ $? -ne 0 ]]; then
   printf "Docker  is ${br}not running.${ar}\n";
 else
  printf "Docker is ${bg}running.${ar}\n";
fi
