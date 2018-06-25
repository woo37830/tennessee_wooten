#!/usr/bin/perl
#
		@keys = (
			'e',    # set email reader
			'l',    # sets either menus or unix commands
			'v',	# views configuration settings			
			'i',	# set editor to vi or pico
		);

		%keys_expect_value = (
			'e', '',
			'l', '',
			'i', '',
		);

&process_arguments;

open(DOTMENU,"$ENV{'HOME'}"."/.menu") || &fix_menu;

$index = 0;
$unix = 0;	# assume menus
while (<DOTMENU>) {
	if ($_ =~ /MENUCMD/) { $menucmd = 1; }
	else { $ary[$index++] = $_; }
}
close(DOTMENU);
if ($menucmd) { $unix = 0; }	# menus specified
else { $unix = 1; }		# unix command line specified

if (defined $keys_value{'e'}) {
	print "\nSetting mail reader to $keys_value{'e'}...\n\n";
	$mailreader=0;
	for ($i = 0; $i <= $#ary; $i++) {
		if ($ary[$i] =~ /MAILREADER/) {
			$mailreader = 1;
			$ary[$i] = "setenv MAILREADER $keys_value{'e'}\n";
		}
	}
	if (!$mailreader) {
		$ary[$i] = "setenv MAILREADER $keys_value{'e'}\n";
	}
	open(TMP,">>/tmp/$ENV{'USER'}.menu-tmp");
	print TMP "setenv MAILREADER $keys_value{'e'}\n";
	close(TMP);
}

if (defined $keys_value{'l'}) {
	$l = $keys_value{'l'};
	for ($i = 0; $i <= $#ary; $i++) {
		if ($ary[$i] =~ /^\$MENUCMD/) {
			$ary[$i] = '';
		}
	}
	if ($l eq 'unix') {
		$unix = 1;
		print "You will not use menus when you login.\n\n";
	}
	if ($l eq 'menu') {
		$unix = 0;
		print "You will use menus when you login.\n\n";
	}
}

	
if (defined $keys_value{'v'}) {
	print "\n";
	print "				Oak Ridge Educational Network\n";
	print "				  Personal Configuration\n";
	print "				  ----------------------\n\n";
	$whoami=`whoami`;
	chop $whoami;
	$host=`hostname`;
	chop $host;
	print "\t\tElectronic Mail Address: $whoami@$host\n\n";
	print "\t\tTerminal Type: $ENV{'TERM'}\n\n";
	open(DOTMENU,"$ENV{'HOME'}"."/.menu");
	$index=0;
	while (<DOTMENU>) {
        	$ary[$index++] = $_;
	}
	$menus=0;	# use menus?
	for ($i = 0; $i <= $#ary; $i++) {
		if ($ary[$i] =~ /EDITOR/) {
			if ($ary[$i] =~ /vi/) {
			print "\t\tDefault Editor: vi\n\n";
			}
			else {
				if ($ary[$i] =~ /pico/) {
					print "\t\tDefault Editor: pico\n\n";
				}
			} # else
		}
		if ($ary[$i] =~ /MAILREADER\s+(\w+)/) {
			print "\t\tMail reader: $1\n\n";
		}
		if ($ary[$i] =~ /\$MENUCMD/) {
			print "\t\tMenus executed automatically upon login: yes\n\n";
			$menus=1;
		}
	}
	if (!$menus) {
		print "\t\tMenus executed automatically upon login: no\n\n";
	}
	close(DOTMENU);
}


if (defined $keys_value{'i'}) {  # change default editor
	$l = $keys_value{'i'};
	print "\nSetting default editor for the News and Conferences program to $keys_value{'i'}...\n\n";
	print "You will need to log out and log back in before this change takes effect\n\n";
	$editor = "setenv EDITOR $keys_value{'i'}\n";
#	if ($l eq 'vi') {
#		$editor="setenv EDITOR /usr/ucb/vi\n";	
#	}
#	if ($l eq 'pico') {
#		$editor="setenv EDITOR /usr/local/bin/pico\n";	
#	}
	$edit=0;
	for ($i = 0; $i <= $#ary; $i++) {
		if ($ary[$i] =~ /EDITOR/) {
			$edit = 1;
			$ary[$i] = $editor;
		}
	}
	if (($editor ne "") && (!$edit)) {
		$ary[$i] = $editor;
	}
	open(TMP,">>/tmp/$ENV{'USER'}.menu-tmp");
	print TMP "setenv EDITOR $keys_value{'i'}\n";
	close(TMP);
}


if (!defined $keys_value{'v'}) { # Write changed .menu
	open(DOTMENU,">$ENV{'HOME'}"."/.menu");
	for ($i = 0; $i <= $#ary; $i++) {
		print DOTMENU $ary[$i] unless $ary[$i] eq '';
	}
#	if (defined $keys_value{'l'}) {
		if (!$unix) {
			print DOTMENU "\$MENUCMD\n";
		}
#	}
	close(DOTMENU);
}


sub process_arguments {
	#
	#	Entry:	@keys is an array whose elements are
	#			strings representing potential arguments
	#		%keys_expect_value is an associative array whose 
	#			elements are defined if $keys[string] expects
	#			a value.
	#		@ARGV is assumed to contain words from the
	#			from the command line		
	#		-- as an argument stops argument processing,
	#			i.e. the rest of the words are files
	#
	#	Exit: Arguments expecting values:
	#		If a value expecting argument was specified
	#		on the command line,
	#		$keys_value{"argument name"} = "argument value" or 1
	#			else its undefined
	#
	#
	#	Example of entry conditions:
	#	@keys = (
	#		'a',    # alphabet soup
	#		'bz',   # by zeros
	#		'f',    # filename to write
	#		'bc',   # byte count
	#		);
	#	%keys_expect_value = (
	#		'f', '',
	#	);
	#
		local($[) = 0;	# Lets not play games
	argument: while ($#ARGV + 1) {	# Scan command line arguments
		local($arg) = $ARGV[0];
		if ($arg eq '--') { shift @ARGV; last; }
		$arg =~ s/^-//;	# Allow leading - (minus)
		$nomatch = 1;
		foreach $i (@keys) {
			if( $i ne $arg) {next;}
			$nomatch = 0;
			$keys_value{$i} = 1;
			if( defined $keys_expect_value{$i} ) { 
				shift @ARGV;
				$keys_value{$i} = $ARGV[0];
			}
			shift @ARGV;
			next argument;
		}
		if ($nomatch) {last;} # Leave ARGV positioned at filenames
	}
}

# execute fix_menu only if there's not a .menu file in the user's home
# directory

sub fix_menu {
		open(DOTMENU,">$ENV{'HOME'}"."/.menu");
		print DOTMENU "setenv TERM vt100\n";
		print DOTMENU "setenv MAILREADER pine\n";
		print DOTMENU "setenv EDITOR /usr/bin/pico\n";
		print DOTMENU "\$MENUCMD\n";
		close(DOTMENU);
		open(DOTMENU,"$ENV{'HOME'}"."/.menu") || die "Big Problem, Buddy: $!\n";
}
