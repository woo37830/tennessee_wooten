#!/bin/bash
#
# Test to see if running in sudo or as root
#
if [ "$(id -u)" != "0" ]; then
    echo "Sorry, you are not root"
    exit 1
fi
echo "All Done!"
