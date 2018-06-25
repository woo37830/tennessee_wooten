#!/usr/bin/perl
#
# Usage: time_track_report.pl
# Author: woo
# Since: 20180625
#
# Open the time_track.txt file where time_track.tcl places its data
# and print out a report summarizing by day, month, year, and client
# Lesson Learned: The format string can confuse you when you're printout 
# doesn't match the expected value.  For instanc, @####### will not print
# '34:15' to look correct, but rather only the 34 part.  Change it to 
# a string @<<<<<<<<<<<<<< and it print fine.

# First open my database.  Complain if unable.

open(STUFF, "/Users/woo/.time_track/time_track.txt") || die "Can't open datafile: $!\n";


while(<STUFF>)  {

    # Split the record into its fields.

    next unless /^\((.*)\s-\s(.*)\)\s(.*)@(.*)$/;
#  /^(.*)\s-\s/;

    # Append to current list.  (Note .= assignment operator.)
    $client = $4;
    $task = $3;
    $start = $1;
    $end = $2;
#    print "\n $start, $end, '$task', $client";
    @info = ($start,$end,$task);
#    print "\n@info";
    push @{$client_list{$client}}, @info;
    print "\n\t$client";
    print " " x (16 - length($client));
    print "\t$info[0]";
    print " " x (32 - length($info[1]));
    print "$info[1],\t$info[2]";
    @item = pop(@{$client_list{$client}});
    print ",\t$item[1]";
    push @{$client_list{$client}}, @item;
}
# Now print the inverted entries out.
print "\nClient          Task\n";
print "_________       ____________\n";
foreach $client (sort keys(%client_list))  {
    print "\n$client";
    $client_total = 0;
    $current_year_total = 0;
    $current_mon_total = 0;
    $current_day_total = 0;
    $current_year = 0;
    $current_mon = 0;
    $current_day = 0;
    print "\n";
    $i = 0;
    while ($i <= $#{$client_list{$client}}-2) {
        $start = $client_list{$client}[$i];
        $end = $client_list{$client}[$i+1];
        @times = &elapsed($start,$end);
        if( $times[0] != $current_year ) {
            print "\n\tTotal for year: $current_year: $current_year_total\n" unless $current_year == 0;
            $client_total += $current_year_total;
            $current_year = $times[0];
            $current_mon = $times[1];
            $current_day = $times[2];
            $current_year_total = 0;
            $current_mon_total = 0;
            $current_day_total = 0;
        } else {
        }
        if( $times[1] != $current_mon ) {
            $period = "Daily";
            $total = $current_day_total;
            $ttotal = &nice_time($total);
            $current_line = $-;
            $~ = "ENDING";
            write;
            $period = "Monthly";
            $total = $current_mon_total;
            $ttotal = &nice_time($total);
            $current_line = $-;
            $~ = "ENDING";
            write;
            $~ = "STDOUT";
            $- = $current_line+2;
#            print "\n\tTotal for month: $current_mon: $current_mon_total\n"; 
            $current_year_total += $current_mon_total;
            $current_mon = $times[1];
            $current_day = 0;
            $current_mon_total = 0;
            $current_day_total = 0;
        } else {
#            $current_mon_total += $current_day_total;
        }
        if( $times[2] != $current_day ) {
#            print "\n\tTotal for day: $current_day: $current_day_total\n";
            &print_total("Daily", $current_day_total);
            $current_mon_total += $current_day_total;
            $current_day = $times[2];
            $current_day_total = $times[3] unless $times[3] < 0;
            $current_day_total = 0 if $times[3] <= 0;
        } else {
            $current_day_total += $times[3] unless $times[3] < 0;
#            print "\n\t\tAdd $times[3] to get Current_day_total = $current_day_total\n";
        }
        $task = $client_list{$client}[$i+2];
        write;
        $i = $i + 3;
    }
    &print_total("Daily", $current_day_total);
    $current_mon_total += $current_day_total;
    &print_total("Monthly", $current_mon_total);
    $current_year_total += $current_mon_total;
    &print_total("Yearly", $current_year_total);
    $client_total += $current_year_total;
    &print_total("Client", $client_total);
}
close(STUFF);
print "\n57->".&nice_time(57);
print "\n'57'->".&nice_time("57");
print "\nAll Done!\n";
sub elapsed {
    $start_str = $_[0];
    $end_str = $_[1];
    my ($start_mon,$start_day,$start_year,$start_hr,$start_min) = ( $start_str =~ m/([0-9]{2})\/([0-9]{2})\/([0-9]{4}) ([0-9]{2}):([0-9]{2})/ ); 
    my ($end_mon,$end_day,$end_year,$end_hr,$end_min) = ( $end_str =~ m/([0-9]{2})\/([0-9]{2})\/([0-9]{4}) ([0-9]{2}):([0-9]{2})/ ); 
    my $time = ($end_hr - $start_hr) * 60 + ($end_min - $start_min);
    return ($start_year, $start_mon, $start_day, $time);
}
sub nice_time {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime($_[0]*60);
#    return ("Total Execution time: $yday days $hour hours $min minutes $sec seconds\n");
    $min = $min+1 if( $sec >= 30 );
    $hour = $hour+1 if( $min > 59);
    return "$hour:$min";
}
sub print_total {
    if( $_[1] != 0 ) {
        $period = $_[0];
        $total = &nice_time($_[1]);
        $current_line = $-;
        $~ = "ENDING";
        write;
        $~ = "STDOUT";
        $- = $current_line+2;
    }
}
sub elapsed_prt {
    my $ret;
    if( $_[0] > 0 ) {
        $ret = $_[0];
    } else {
        $ret = 0;
    }
#    $ret;
    &nice_time($ret);
}


format STDOUT =
@<<<<<<<<<<<<<<<      @<<<<<<<<<<<<<<<<    @<<<<<<<<<<<<         @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$start,          $end,             &elapsed_prt($times[3]),           $task
.
format ENDING =
========
@<<<<<<<<<   Total:  @<<<<<<<<<<<<<<<<
$period, $total                      

.


