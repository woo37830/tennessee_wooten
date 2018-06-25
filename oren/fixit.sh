# @(#)  Generate pwrds from make-Classxx pgm. Users Classxx.pwd (watch uid's)
#	Usage...    xferusers.sh Classxx
#
awk -F: -f nu1.awk < $1.passwd | sh
awk -F: -f nu2.awk < $1.passwd | sh
#niload passwd / < $1.passwd

