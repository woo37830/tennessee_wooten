#!/usr/bin/perl

while (<>) {
	chop;
	if ($_ =~ /\s*(\S+)\s*(\S+)\s*/)	{
		next if ($1 eq 'total');
		$users{$1} = $2;
	}
}
&total_summary(%users);

sub total_summary	{
	local(%users) = @_;
	local($total_time);
	$date = `/bin/date` ;
	print "Usage Report for All Users \n";
	$~ = 'SUMMARY';
	foreach $user (sort keys %users)	{
		$total_time += $users{$user};
		if ($users{$user} <= 10)	{
			$cost = 20;
		} else	{
			$cost = $users{$user}*2;
			}
	@passwd = getpwnam($user);
	$name = $passwd[6];
	$name =~ s/,.*//;
	write ;
	}
	print "Total Connect Time As of $date = $total_time\n";
}

format SUMMARY =
@<<<<<<< @<<<<<<<<<<<<<<<<<<    @##.##       @##.##
$user, $name, $users{$user}, $cost
.

