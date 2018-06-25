#!/usr/bin/perl
#
$log = "/private/var/log/system.log";

open( LOGFILE,  $log ) || die "Unable to open file: $log\n";
$last = "Not found\n";

while(<LOGFILE>) {
    chop($_);
    next unless /(^.*\d\d:\d\d:\d\d).*backupd\[(.*)\]\: (.*$)/;
    $stamp = $1;
    $pid = $2;
    $result = $3;
    if( $result =~ /Backup completed/ ) {
        $last = "$pid: $stamp $result\n";
    }
    else {
        $last = "$pid: $stamp $result\n";
    }
}
#print $last;
system( "growlnotify -m \"$last\"");

