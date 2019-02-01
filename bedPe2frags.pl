#!/usr/bin/perl -w
use strict;

while(<>)
{
	chomp;
	my($chr1, $beg1, $end1, $id1) = split(/\t/);
	$_ = <>;
	my($chr2, $beg2, $end2, $id2) = split(/\t/);
	die if $chr1 ne $chr2;
	($id1) = split(/\//, $id1);
	($id2) = split(/\//, $id2);
	die if $id1 ne $id2;
	my @v = sort(($beg1, $beg2, $end1, $end2));
	print join("\t", $chr1, shift @v, pop @v), "\n";
}
