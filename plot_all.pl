#!/usr/bin/perl -w
use strict;

foreach my $f (@ARGV)
{
	open(G, "|gnuplot");
	print G "set terminal png\n".
	"set output \'$f.png\'\n".
	"plot \'$f\' u 1:2 w l\n";
	close G;
}
