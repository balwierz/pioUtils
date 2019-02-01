#!/usr/bin/perl -w
use strict;

my $start; 
if(not defined $ARGV[0])
{
	$start = ".";
}
else
{
	$start = $ARGV[0];
}
 
if(! -d $start)
{
	print "$start not a directory!";
	exit 1;
}

my @files = split("\n", `find "$start" -maxdepth 1 -type d`);
my @out = ();
foreach my $f (@files)
{
	next if $f eq "..";
	my $fileCount = `find "$f" -type f | wc -l`;
	chomp $fileCount;
	push @out, [$fileCount, $f];
}
@out = sort {$a->[0] <=> $b->[0]} @out;
foreach my $pair (@out)
{
	print $pair->[0], "\t", $pair->[1], "\n";
}
