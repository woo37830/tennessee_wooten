#!/usr/bin/perl
#
# for a list of files from ls -1, create table rows in tex
# To insert a "tab" at the beginning 
# Use: list2textable.pl -tab
#
# Verson: 1.0
# Author: John Wooten, Ph.D.
# Date: 23 April 2014
#

while(<STDIN>)  {
 s/\n/ \& \& \\\\ \n/g;
 s/_/\\_/g;
if(  @ARGV == 0 ) {
    print $_;
} else {
    print "\\qquad $_";
}
}
