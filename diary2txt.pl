#!/usr/bin/perl
#
open(DIARY,"/Users/woo/.diary") || die("Failed to open input");
open(TXT,">/Users/woo/Dropbox/Personal/Documents/Notes/diary_2013.txt") || die("Failed diary_2013.txt");
#
$kount=0;
while(<DIARY>){
chop;
	#	print "$_\n";
   next unless (/2013/);
   print TXT "$_\n";
	while(<DIARY>) {
		chomp;
		next if (/2014/);
	#	next if( $k++ > 100 );
		print TXT "$_\n";
	}
}
#
print "\nAll Done\n";
close (DIARY);
#
