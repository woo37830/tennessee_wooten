#!/usr/bin/perl


unless ( open(DIR, " ls | "))
{
	die( "can't open directory $dir \n");
	}
	
while(<DIR>)
{
	chop;
	next unless $_ =~ '.java';
	unless( open( FILE, $_ ) )
	{
		print "Can't open file:$_\n";
		}
	#	print " : $_\n";
#		print "File: $_\n";
		while( <FILE> )
		{
			chop;
#			print "   Line: $_\n";
			if ($_ =~ 'public class')
			{
				($child) = /public class (\S+)/;
				($parent) = /extends (\S+)/;
#				print $parent," ",$child,"\n";
				$parent =~ s/COM\.mba\.ef\.baseModel\.//g;
				$parent =~ s/COM\.mba\.ef\.rootModel\.//g;
				$parent =~ s/Impl//g;
				$parent =~ s/Ef//g;
				$child =~ s/COM\.mba\.ef\.baseModel\.//g;
				$child =~ s/COM\.mba\.ef\.rootModel\.//g;
				$child =~ s/Impl//g;
				$child =~ s/Ef//g;
				$children = $classes{ $parent };
				$children .= "|".$child;
				$classes{ $parent } = $children;
				close( FILE );
			break;
			}
		}

	}
			$level = 0;
			foreach $target (sort keys(%classes))  	{
				&prtsubclasses( $target );
				}
			
	sub prtsubclasses	{
		local ( $key ) = @_;
		local ( $achild, @children );
				return if( $key =~ /Carpet/ );
				return if( $key =~ /Steel/ );
				return if( $key =~ /ForecastDemand/ );
				return if( $key =~ /DemandPlan/ );
				return if( $key =~ /Store/ );
				return if( $key =~ /Warehouse/ );
				@children = split(/\|/, $classes{ $key } );
				$indent = $level;
				while ( $indent != 0 )	{
					print "   ";
					--$indent;
					}
				$key =~ s/Perspective/Context/g;
				$key =~ s/Demand/Deliverable/g;
				print $key,"\n";
				if( $#children <= 1 )	{
					return;
					}
				$level++;
				shift(@children);					
				while(@children)	{
					$achild = shift(@children);
					&prtsubclasses( $achild );
					}
				$level--;
				return;
	}

