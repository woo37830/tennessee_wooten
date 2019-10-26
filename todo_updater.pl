#!/usr/bin/perl
#
$diary = "/Users/woo/Dropbox/Personal/Documents/Notes/.diary";
$todo = "/Users/woo/Dropbox/Personal/Documents/Notes/.todo";

open( DIARY, $diary ) || die "Unable to open file: $diary\n";
#open( TODO, "+>$todo" ) || die "Unable to open file: $todo for read/write\n";

# Loop through diary looking for TODO-YYYYMMDD:HHMM[(C)][(R)][(CR)]).
# Where (C) means move to calendar, (R) means move to Reminders, (T) would mean ToDo
# Add the indented lines following to the todo file.
# If a DONE-YYMMDD:HHMM, is found, find that in the todo and remove it if present.

while(<DIARY>) {
    chop($_);
    next unless /(^TODO)/;
    print "$_\n";
}
print "All Done!\n";

