#!/bin/bash

. utilities.sh

question="Continue?"; ask
if [ $ans != "Y" ]; then
    echo "OK, have a nice day"
    exit
fi
