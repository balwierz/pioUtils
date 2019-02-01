#!/usr/bin/perl -w
#SBATCH -J bam2interaction
#SBATCH -c 2
use strict;
use IPC::Open2;
my $filterChrM = 1;


my $bamF = shift @ARGV or die "please provide ID-sorted bam file\n";
open(my $pH, "-|", 'bedtools', 'bamtobed', '-bedpe', '-i', $bamF) or die;
my $pid = open2(my $sortOutH, my $sortInH, 'pioSortBed', '--sort=b', '--collapse', '-') or die;
print STDERR "got $pid\n";
while(<$pH>)
{
	my($chr0, $beg0, $end0, $chr1, $beg1, $end1) = split(/\t/);
	next if $chr0 ne $chr1; # let's ignore such reads for now
	next if $chr0 eq '.' || $chr1 eq '.';
	next if $chr0 eq 'chrM';
	print $sortInH join("\t", $chr0, $beg0, $end1, '.', '1', '.'). "\n";
}
close $pH;

my $intID=0;
while(<$sortOutH>)
{
	my($chr, $beg, $end, $id, $score, $str) = split(/\t/);
	print join("\t", $chr, $beg, $beg+1, $chr.':'.$end.'-'.($end+1).','.$score, $intID, '.'), "\n";
	print join("\t", $chr, $end, $end+1, $chr.':'.$beg.'-'.($beg+1).','.$score, $intID++, '.'), "\n";
}


