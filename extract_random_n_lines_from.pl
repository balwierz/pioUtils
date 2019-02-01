#!/usr/bin/perl -w
use strict;

my($n, $file) = @ARGV;
open(A, $file) or die;
my @l = <A>;
close A;

die "number of lines bigger than file size\n" if @l < $n;
while($n)
{
	my($out) = splice(@l, int rand scalar(@l), 1);
	$n--;
	print $out;
}
