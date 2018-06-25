#!/usr/bin/perl

open(PASSWD,"nidump passwd . |") || die ("Password file not available\n");
while(<PASSWD>)	{
	chop;
	($userid,$pw,$uid,$gid,$name,$rest,$shell) = split(':',$_);
	next if ($uid < 100);
	$cmd = "/bin/chgrp -R $gid $userid; /etc/chown -R $userid $userid";
	system( "$cmd" );
		printf("$userid fixed\n");
	}
close(PASSWD);
