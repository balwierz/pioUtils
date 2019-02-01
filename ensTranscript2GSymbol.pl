#!/usr/bin/perl -w
use strict;

my $genome = "danRer7";
my $trF = "/mnt/biggles/data/ucsc/danRer7-full/database/ensemblToGeneName.txt.gz";

my($f, $column) = @ARGV;
# column numbers counted from 1

my %h;
open(my $fH, "less $trF |") or die;
while(<$fH>)
{
	chomp;
	my($t, $symb) = split(/\t/);
	$h{$t} = $symb;
}
close $fH;

open($fH, $f) or die;
open(my $oH, '>', $f.".gsymb") or die;
while(<$fH>)
{
	chomp;
	my @v = split(/\t/);
	# substitute the gene:
	$v[$column-1] = exists $h{$v[$column-1]} ? $h{$v[$column-1]} : "";
	print $oH join("\t", @v), "\n";
}
close $fH;
close $oH;
