#!/usr/bin/perl
@Elvis = 1..1321;
{
   local(@temp);
   push(@temp, splice(@Elvis, rand(@Elvis),1))
       while @Elvis;
   @Elvis = @temp;
}
open (USERS,"cohort.new") || die ("Can't open list of users!");
$k = 1;
%userlist;
while (<USERS>) {
   chop;
   $userlist {$k} = $_;
   $k += 1; 
   }
for ($i = 0; $i < 103; $i++)	{
	$sample_id = $Elvis[$i];
	printf("%d %s\n", $i,$userlist{$sample_id});
	}

