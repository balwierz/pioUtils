#!/usr/bin/perl -w
use strict;
use File::Basename;

my $f = shift @ARGV;
my $b = basename($f, '.bed');  #usually there is no .bed anyway

foreach my $strand (('+', '-'))
{
	open(my $fH, $f) or die;
	open(my $oH, ">", "$b.$strand.tmp") or die;
	$_ = <$fH>; #header
	while(<$fH>)
	{
		chomp;
		my(@v) = split(/\s+/);
		if($v[5] eq $strand)
		{
			print $oH join "\t", $v[0], $v[1]-1, $v[2], $v[7];
			print $oH "\n";
		}
	}
	close $fH;
	close $oH;
	system("bedGraphToBigWig", "$b.$strand.tmp", '/mnt/biggles/data/UCSC/goldenpath/danRer7/chromInfo.txt', "$b.$strand.bw");
	unlink "$b.$strand.tmp";
}
