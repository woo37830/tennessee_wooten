#! /bin/csh -f
#
#  tmp & log directory clean up
#
#  Settings:
#     xeq   -  0: for testing
#              1: to execute
#     old   -  how many days back are files to be deleted
#
#  Notes for "find":
#  1. -maxdepth 1 -  only looks at the current directory
#  2. -type f     -  restrict to files only
#
set xeq = 1
set old = "+7"
#
#  delete old files from select directories
set dir_list = (  /usr/local/logs/sc_demo /private/var/tmp  )
foreach d ($dir_list)
   echo "Cleaning: $d"
   cd $d
   if ($xeq) then
      /usr/bin/find . -maxdepth 1 -type f -mtime $old -exec rm -rf {} \;
   else
      /usr/bin/find . -maxdepth 1 -type f -mtime $old -exec ls -ld {} \;
   endif
end

#
#  delete old files ending with ".gz" in /private/var/log
#cd /private/var/log
#echo "Checking: /private/var/log"
#if ($xeq) then
#  /usr/bin/find . -maxdepth 1 -type f -name "*.gz" -mtime $old -exec rm {} \;
#else
#  /usr/bin/find . -maxdepth 1 -type f -name "*.gz" -mtime $old -exec ls -ld {} \;
#endif
#
