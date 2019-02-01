#!/usr/bin/perl -w
use File::Basename;
#SBATCH -c 2
#my $ext=1;

my $chromInfoF = '/mnt/biggles/data/UCSC/goldenpath/danRer7/chromInfo.txt';
use strict;
my ($f) = @ARGV;
die "usage bam2ends.pl file.bam [outfile_+.bed outfile_-.bed]\n" unless defined $f and $f =~ /\.bam$/;

my %h;

# loop over replicates
foreach my $f (@ARGV)
{
	next if $f !~ /\.bam/;
	open(my $P, '-|', "bedtools", "bamtobed", "-i", $f) or die;
	my $line=0;
	while(<$P>)
	{
		if(!(++$line%1000000))
		{
			print STDERR "bam2ends.pl: processed ".($line/1000000)." M reads.\n";
		}
		chomp;
		my($chr, $beg, $end, $id, $score, $str) = split(/\t/);
		next if $chr eq 'chrM';
		if($str eq '+')
		{
			$h{'+'}{$chr}{$beg} ++
		}
		elsif($str eq '-')
		{
			$h{'-'}{$chr}{$end-1} -- 
		}
		else {die "'$str' is not strand\n"}
	}
	close $P;
}

my $stub = basename($f);
$stub =~ s/\.bam$//;
foreach my $str (('+', '-'))
{
	my $ff = "$stub.5prim.$str.bg";
	print STDERR "Writing strand $str to $ff\n";
	open(my $oH, '>', $ff) or die;
	foreach my $chr (sort keys %{$h{$str}})
	{
		foreach my $pos (sort {$a <=> $b} keys %{$h{$str}{$chr}})
		{
			# //twice $pos is intended, because it is a cut site which is BETWEEN nucleotides.
			print $oH join("\t", $chr, $pos, $pos+1, $h{$str}{$chr}{$pos}), "\n";
		}
	}
	close $oH;
	system('bedGraphToBigWig', $ff, $chromInfoF, "$stub.5prim.$str.bw");
}
