#!/usr/bin/env perl
#
# Go through the Projects in the input directory and for each .cs file
# pull out the lines that contain LogInfo("something", or LogError("something",
# or LogWarning("something", and extract the Info/Error/Warning part
# and the something.  Sort them and print the unique ones.
#

$num_args = $#ARGV + 1;
if ($num_args != 1) {
   print "\nUsage: list_log_values.pl project_directory\n";
   exit;
}
$directory = $ARGV[0];

opendir( my $DIR, $directory );
while ( my $entry = readdir $DIR ) {
#   print $entry . "\n";
   next unless -d $directory . '/' . $entry;
   next if $entry eq '.' or $entry eq '..';
#   print "$entry\n";
   opendir( my $PROJ,  $directory . '/' . $entry ) or die "Cannot open directory: $directory . '/' . $entry";
   my @files = readdir $PROJ;
   closedir $PROJ;
   foreach my $file (@files) {
      next if($file =~ /^\.$/);
      next if($file =~ /^\.\.$/);
      next unless $file =~ /.cs$/;
#      print "\t$file\n"; 
      open my $FILE, '<', $directory . '/' . $entry . '/' . $file or die "Can't open file: $file";
      my $regex = /^.*Log[^\.](.*)\(\"(.*)\",.*$/;
      while (<$FILE>)
      {
          next unless $_ =~ "Log([^\.].*)\"(.*)\",";
         {
            print  "$1\t$2\n";
         }
      }
   }
}
closedir $DIR;
exit;

    
