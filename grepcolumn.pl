#!/usr/bin/perl -w
use strict;

my %h;
my($pattf, $targf, $coln, $otherf) = @ARGV;
open(P, $pattf) or die "usage: patternFile targetFile columnNumber [otherFile]\n";
while(<P>)
{
	chomp;
	$h{$_} = 1;
}
close P;

if(defined $otherf)
{
	open(O, $otherf) or die;
}
open(T, $targf) or die;
for(my $i=1; ;$i++)
{
	my $line = <T>;
	my $line2;
	if(defined $otherf)
	{
		$line2 = <O>;
		chomp $line2;
	}
	if($line)
	{
		chomp $line;
		my @v = split(/\s/, $line);
		if(defined $v[$coln] && $v[$coln])
		{
			if(if exists $h{$v[$coln]})
			{
				print $line;
				if(defined $otherf)
				{
					print "\t".$line2;
				}
				print "\n" ;
			}
		}
	}
	else
	{
		last;
	}
}
close T;
if(defined $otherf)
{
	close O;
}
