#!/usr/bin/perl -w
use strict;

my $base = shift @ARGV;

while(<>)
{
	print $base**$_, "\n";
}
