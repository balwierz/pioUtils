#!/usr/bin/perl -w
use strict;

open(my $fH, shift @ARGV) or die "cannot open file\n";
while(<$fH>)
{
	if(/^\d/)
	{
		my @v = split(/\s+/);
		print $v[0], "\t-", $v[1], "\n";
	}
	else
	{
		print
	}
}
close $fH;
