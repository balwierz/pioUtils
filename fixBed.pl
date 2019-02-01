#!/usr/bin/perl -w
use strict;

my($inF, $outF) = @ARGV;
my $genomeF = "/mnt/biggles/data/UCSC/goldenpath/danRer7/chromInfo.txt";
my %chr2len;
open(my $cH, $genomeF) or die;
while(<$cH>)
{
	chomp;
	my @v = split(/\s+/);
	$chr2len{$v[0]} = $v[1];
}
close $cH;
open(my $inH, $inF) or die;
open(my $outH, '>', $outF) or die;
while(<$inH>)
{
	chomp;
	my @v = split(/\s+/);
	next if not defined $chr2len{$v[0]};
	if($v[1] < 0) {$v[1]=0}
	if($v[2] > $chr2len{$v[0]}) {$v[2] = $chr2len{$v[0]}}
	print $outH join("\t", @v), "\n";
}
close $outF;
close $inH;
