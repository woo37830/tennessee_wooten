#!/usr/bin/env python

import sys
import os
# -*- coding: utf-8 -*-
# command-line input
help_text = """Usage: joinstl.py <directory> <output file>"""
 
try:
    if len(sys.argv) < 2:
        raise ValueError
 
    directory = sys.argv[1]
 
except:
    print sys.argv
    print help_text
    sys.exit() 
# the directory of your STL files
 
# STL files that will be merged into one
input_names = os.listdir(directory)
 
# name of the output STL file
output_name = sys.argv[2]
 
############################
############################
############################
extension = ".stl"
 
output_file = open(output_name + extension, "w")
 
for name in input_names:
    f = open(directory + name , "r")
 
    line = f.readline()
    output_file.write("solid " + name + "\n")
 
    line = f.readline()
    while line != "":
        output_file.write(line)
        line = f.readline()
 
    f.close()
 
 
output_file.close()
