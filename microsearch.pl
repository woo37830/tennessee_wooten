#!/usr/bin/perl -w

$done="";
$debug="";
$tree="";

if($ARGV[0])
{
        foreach $arg (@ARGV)
        {
                if    ( $arg eq "-h")       {&printhelp;$done=1;}
                elsif ( $arg eq "-help")    {&printhelp;$done=1;}
                elsif ( $arg eq "-v")       {&printversion;$done=1;}
                elsif ( $arg eq "-version") {&printversion;$done=1;}
                elsif ( $arg eq "-d")       {$debug=1;}
                elsif ( $arg eq "-debug")   {$debug=1;}
                elsif ( $arg eq "-t")       {$tree=1;}
                elsif ( $arg eq "-tree")    {$tree=1;}
                else                        {&descend($arg);$done=1;}
        }
}

if (!$done)
{
        &descend(".");
}
exit();

sub descend
{
        local($thisdir)=@_;
        if(!$thisdir) {return();}
        opendir (DIR, "$thisdir");
        local(@files)=grep (!/^\./,readdir(DIR));
        foreach $file (@files)
        {
                if($debug){print "Considering $file\n";}
                local($newdir)="$thisdir/$file";
                if(($file =~ /\.asm$/)||($file =~ /\.inc$/)||($file =~ /\.m4$/))
                {
                        &scan("$thisdir/$file");
                } elsif ( -d $newdir)
                {
                        if(($debug)||($tree)){print "Decending to $newdir\n";}
                        &descend($newdir);
                }
        }
}

sub scan
{
        local($file)=@_;
        if($debug){print "Scanning $file\n";}
        if(open(IN, "$file"))
        {
                while(<IN>)
                {
                        if( /CODEMACRO/ )
                        {
                                print "$file: $_";
                        }
                }
        } else {
                print "strange... can't open $file\n";
        }
}

sub printversion
{
        print <<ENDOFVERSION;

Mike's microsearch: version 0.1
a search for a seg:reg in assembly files

ENDOFVERSION
}

sub printhelp
{
        print <<ENDOFHELP;

This is a framework script designed to help you do big deep searches for
regular expressions in files. Just edit the stuff you need in a copy of
this file and then fire it off. It will descend trees, search files that
meet a regular expression with their name and find regular expressions
inside them. It may also make a good framework for more advanced work if
you so desire.

Some options:

-h -help     prints this information
-v -version  prints the current "version"
-d -debug    prints debugging information
-t -tree     prints out the tree as it descends it

Enjoy :-)

ENDOFHELP
}
