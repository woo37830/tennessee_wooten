#!/bin/bash
#
# Create a file containing the environment variables of interest
#
ruby -v > ~/Desktop/env.txt
rails --version >> ~/Desktop/env.txt
echo '---------Gems---------' >> ~/Desktop/env.txt
gem list >> ~/Desktop/env.txt
echo 'All Done!'