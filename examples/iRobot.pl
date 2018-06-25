#!/usr/bin/perl -w
#
# roomba-tilt.pl
# --------------
# Use the MacBook's accelerometers (tilt sensors) to drive the Roomba.
# This is also a decent exploration of how to control a Roomba from Perl.
#
#
# Created 7 December 2006
# Copyleft (c) 2006, Tod E. Kurt, tod@todbot.com, ThingM
# http://hackingroomba.com/
#
# Notes:
# With AMSTracker, my MacBook spits out:
#  - more negative Z when tilted away from me
#  - more positive Z when tilted toward me
#  - more negative X when tilted to the right
#  - more positive X when tilted to the left
#  - the 'y' value doesn't change in an interesting way
#

use strict;
use warnings;
use Getopt::Long;
use Time::HiRes qw( sleep );

my $me = "roomba-tilt.pl";
sub usage() {
    print <<EOF;
Usage: $me -p <serial_port> [options]

Options:
  -p <serial_port>      Serial port of Roomba (e.g. "/dev/tty.RooTooth")
  -fourway              Change to D-pad mode instead of normal proportional
  -fullmode             Turn off Roomba safety mode (watch out!)
  -d|-deadzone <n>      Set center deadzone (normally 15)
  -u|-update_rate <f>   Set update rate in seconds (normally 0.25) 
  -tracker <path>       Set AMSTracker path (if not in PATH)
  -v|-verbose           Output internal info
  -h|-help              This screen

EOF
    exit;
}

my $verbose = 0;

sub roomba_init($;$) {
    my ($port,$fullmode) = @_;
    $fullmode ||= 0;  # default
    print "roomba_init: $port ".(($fullmode)?"(fullmode)":"")."\n" if($verbose);
    my $stty_args = '57600 raw -parenb -parodd cs8 -hupcl -cstopb clocal';
    # pick operating system (in case there are people using Linux for this)
    my $uname = `uname`; chomp $uname;
    if( $uname eq 'Linux' ) {
        system("stty -F $port $stty_args");
    } elsif( $uname eq 'Darwin' ) {  # aka Mac OS X
        system("stty -f $port $stty_args");
    }
    my $roomba;
    open $roomba, "+>$port" or die "couldn't open port: $!";
    select $roomba; $| =1;  # make unbuffered
                                                         # ROI commands
    print $roomba "\x80";  sleep 0.1;                    # START
    print $roomba "\x82";  sleep 0.1;                    # CONTROL
    if( $fullmode ) { print $roomba "\x84"; sleep 0.1; } # FULL
    # show we are initialized by moving forward a bit
    roomba_forward($roomba); sleep 0.5;
    roomba_stop($roomba);    sleep 0.3;
    return $roomba;
}
sub roomba_drive($$$) {
    my ($roomba,$vel,$rad) = @_;
    printf("roomba_drive: %hx,%hx\n",$vel,$rad) if($verbose);
    my $vh = ($vel>>8)&0xff;  my $vl = ($vel&0xff);
    my $rh = ($rad>>8)&0xff;  my $rl = ($rad&0xff);
    printf $roomba "\x89%c%c%c%c", $vh,$vl,$rh,$rl;      # DRIVE + 4 databytes
}
sub roomba_forward($) {
    my ($roomba) = @_;
    roomba_drive($roomba, 0x00c8, 0x8000); # 0x00c8= 200 mm/s, 0x8000=straight
}
sub roomba_backward($) {
    my ($roomba) = @_;
    roomba_drive($roomba, 0xff38, 0x8000); # 0xff38=-200 mm/s, 0x8000=straight 
}
sub roomba_spinleft($) {
    my ($roomba) = @_;
    roomba_drive($roomba, 0x00c8, 0x0001); # 0x00c8= 200 mm/s, 0x0001=spinleft
}
sub roomba_spinright($) {
    my ($roomba) = @_;
    roomba_drive($roomba, 0x00c8, 0xffff); # 0x00c8= 200 mm/s, 0xffff=spinright
}
sub roomba_stop($) {
    my ($roomba) = @_;
    roomba_drive($roomba, 0x0000, 0x0000); # all zeros means stop
}

#
#
#
my $tracker_path='';
my $port='';
my $deadzone = 15;
my $update_rate = "0.25";
my $help = 0;
my $fourway = 0;  # old binary mode
my $fullmode = 0;
my $rc = GetOptions( 'port=s' => \$port,
                     'fourway' => \$fourway,
                     'full|fullmode'    => \$fullmode,
                     'deadzone=i' => \$deadzone,
                     'update_rate=f' => \$update_rate,
                     'verbose+' => \$verbose,
                     'help' => \$help,
                     'tracker=s' => \$tracker_path,
                     );
usage() if( $rc==0 or @ARGV>0 or $help or !$port);

my $tracker_url = 'http://www.osxbook.com/software/sms/amstracker/';
if( !$tracker_path ) {
    $tracker_path = `which AMSTracker`; chomp $tracker_path;
    if( $tracker_path =~ /not found/ ) {
        print "Could not find AMSTracker.\n";
        print "Please download it from\n   $tracker_url\n";
        print "And put it in your PATH\n";
        exit(1);  
    }
}

my $roomba;
if( $fullmode ) {
    $roomba = roomba_init($port, 1);
} else { 
    $roomba = roomba_init($port);
}

my ($vel,$rad);
open(ACCELDATA, "$tracker_path -u $update_rate -s |") or die "no tracker: $!";
#select ACCELDATA; $|=1;  # make unbuffered
select STDOUT; $|=1;     # make unbuffered
print "$me running ". ($fourway?"(fourway)":"") .", press ctrl-c to exit\n";
while(<ACCELDATA>) {
    chomp;
    if( /(-?\d+)\s+(-?\d+)\s+(-?\d+)/ ) {
        my ($x,$y,$z) = ($1,$2,$3);
        print "x:$x, y:$y, z:$z\n" if($verbose);
        if( $fourway ) {  # boolean drive, like a D-pad
            if( $x < -$deadzone ) { 
                roomba_spinright($roomba);
            } elsif( $x > $deadzone ) {
                roomba_spinleft($roomba);
            } elsif( $z < -$deadzone ) {
                roomba_forward($roomba);
            } elsif( $z > $deadzone ) {
                roomba_backward($roomba);
            } else {
                roomba_stop($roomba);
            }
        } 
        else {            # proportional drive, like an analog stick
            if( abs($x) < $deadzone && abs($z) < $deadzone ) {
                roomba_stop($roomba);             # in deadzone, so stop
            }
            elsif( abs($z) < $deadzone ) {        # no back-forth,spin in place
                $vel = 50 + abs($x)*3;
                $rad = ($x>0) ? 0x0001 : 0xffff;  # spin left or right
                roomba_drive($roomba, $vel, $rad);
            }
            else {
                $vel = -$z * 5;    # these equations empirically determined
                $rad = ($x>0) ? 762 -($x*6) : -762-($x*6);
                roomba_drive($roomba, $vel, $rad);
            }
        }
    }
}

close ACCELDATA or die "bad $tracker_path: $!";


