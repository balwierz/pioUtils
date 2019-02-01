#!/usr/bin/perl -w
use strict;

my @w;
while(<>)
{
	chomp;
	s/^\s+//;
	push @w, [split(/\s+/)];
}

my $n = scalar (@{$w[0]});
for(my $i=0; $i<$n; $i++)
{
	for(my $j=0; $j<scalar @w; $j++)
	{
		if($j)
		{
			print "\t";
		}
		print $w[$j][$i];
	}
	print "\n";
}
