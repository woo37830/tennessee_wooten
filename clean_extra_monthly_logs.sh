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
set old = "+30"
#
#
#  delete old files from select directories
set dir_list = ( /Library/Tomcat/jakarta-tomcat-4.1.31/logs /Library/Tomcat/apache-tomcat-5.5.12/logs /Library/Tomcat/jakarta-tomcat-5.5.9/logs /Library/Logs/Users/woo/pcpi /Library/Logs/Users/woo/pcpi-bpm /Library/Logs/Users/woo/rcp_tests /Library/Logs/Users/woo/sc_app /Library/Logs/Users/woo/sc_tests /Library/Logs/Users/woo/sc_editor /Users/woo/Library/Logs /Users/woo/Library/Logs/CrashReporter /Users/woo/Library/Logs/Java )
foreach d ($dir_list)
   echo "Checking: $d"
   cd $d
   if ($xeq) then
      /usr/bin/find . -maxdepth 1 -type f -name "*.log*" -mtime $old -exec rm {} \;
   else
      /usr/bin/find . -maxdepth 1 -type f -name "*.log*" -mtime $old -exec ls -ld {} \;
   endif
end

cd /Users/woo/build
/bin/rm -rf Debug* *.build
echo "cleaned /Users/woo/build directory"
