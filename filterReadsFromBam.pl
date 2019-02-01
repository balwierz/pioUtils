#!/usr/bin/perl -w
use strict;
use Getopt::Long;

my $isHeader = '';
GetOptions('h' => \$isHeader);
my($bamF, $readIdF, $outSamF) = @ARGV;
die "Usage: filterReadsFromBam.pl in.bam read.ids.txt out.sam\n" unless @ARGV == 3;
open(my $readIdH, $readIdF) or die "cannot open $readIdF\n";
my %goodReads;
print STDERR "Getting read IDs\n";
while(<$readIdH>)
{
	chomp;
	my ($read) = split;
	$goodReads{$read} = 1;
} 
close $readIdH;
print STDERR (scalar keys %goodReads) . " read IDs read\n";
open(my $outH, '>', $outSamF) or die "Cannot write to $outSamF\n";
my $bamH;
if($isHeader)
{
	open(my $bamH, "-|", "samtools", "view", '-H', $bamF) or die "cannot open bam file through samtools\n";
	while(<$bamH>) { print $outH $_ }
	close $bamH;
}
open($bamH, "-|", "samtools", "view", $bamF) or die "cannot open bam file through samtools\n";
print STDERR "Processing alignments\n";
while(<$bamH>)
{
	my($readID) = split(/\t/);
	print $outH $_ if exists $goodReads{$readID};
}
close $bamH;
close $outH;