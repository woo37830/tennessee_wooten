open(PASSWD,"/etc/passwd") || die ("Password file not available\n");
while(<PASSWD>)	{
	chop;
	next if (/sorry/);
	next if (/false/);
	next if (/sync/);
	next if (/apply/);
	($userid,$pw,$uid,$gid,$name,$rest,$shell) = split(':',$_);
	($fn,$mi,$ln) = split(' ',$name);
	if ($ln eq '' )	{
		$ln = $mi;
		$mi = "";
		}
		else	{
		$mi .= ".";
		}
	printf("%18s,\t%18s\t%s  ->\t%s       (%s)\n",$ln,$fn,$mi,$userid,$shell);
	}
close(PASSWD);
