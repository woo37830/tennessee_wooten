#!/bin/bash

function ask () {
    echo -n "$question> "
    read ans
    case $ans in
        [Yy]*) ans="Y";;
        [Nn]*) ans="N";;
        *)     ans="-";;
    esac
}

function lower()
{
    local str="$@"
    local output
    output=$(tr '[A-Z]' '[a-z]'<<<"${str}")
    echo $output
}

function is-root {
    if [ "$UID" -ne 0 ]
        then echo "Please run as root"
        exit 1
    fi
}

function greet {
    echo Hello, $USER
}