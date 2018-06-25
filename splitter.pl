#!/usr/bin/perl
# Accepts input paths and slits off the first part.
# Stops on an empty line. Does not use args from command line
print "\nEnter a file path or <cr> to terminate\n";
while(<STDIN>)	{
	chop;
	if( $_ eq "" )	{
		print "\n\tAll Done!\n";
		exit;
	}
	@names = split('/');
	print $names[$#names],"\t",$_,"\n" unless /~/;
}
