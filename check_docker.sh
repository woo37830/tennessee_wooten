#!/bin/bash
#
# Check if docker is available and running
#
{
 ## will throw and error if the docker daemon is not running and jump
 ## to the next code chunk
 docker ps -q &> /dev/null
# printf "Docker is \033[1;32mrunning.\033[0m\n";
} || {
  printf "Docker  is \033[1;31mnot running.\033[0m\n";
}
