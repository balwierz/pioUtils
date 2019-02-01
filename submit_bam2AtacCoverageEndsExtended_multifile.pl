#!/usr/bin/perl -w
#SBATCH -c 8
#SBATCH -J extATAC
#SBATCH --mem 8G

# usage:
# $1 - extsize=50
# $2 - output file stub eg ATAC.4cell.someone.2019.danRer7
# $3,... - bam files of ATAC seq
# extsize needs to be even
use strict;
my $extSize = shift @ARGV;
my $outF = shift @ARGV;
my @inputs = ();
foreach my $e (@ARGV)
{
	push @inputs, "--in";
	push @inputs, $e;
}

system('bam2wig.pl',
		'--temp', '/mnt/scratch/piotr',
		'--extend', '--rpm', '--nope', '--shift',
		'--shiftval', (-$extSize/2 + 4),
		'--extval', $extSize,
		'--var', @inputs,
		'--cpu', 8, '--nogz', '--bw',
		'--out', $outF.'.cuts.ext'.$extSize.'.bw')
