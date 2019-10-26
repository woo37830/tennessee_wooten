#!/bin/bash
#
# function to view git diffs
#
usage() {
    echo "Usage: gitlog.sh file-to-compare [how far back] [something]"
    exit
}
gitlog() { git log -${3:-p} -${2:-1} $1; }
#
# call usage if filename not provided
#
[[ $# -eq 0 ]] && usage
gitlog
