#!/mnt/biggles/opt/perl/bin/perl -w
use strict;

# splits wig file by chromosomes
# this is necessery for gffbuilder

open(my $fH, shift @ARGV) or die;
open(my $oH, "/dev/null");
my $lastChr = "";
my $span = 0;
my $predictedPos = 1;
while(<$fH>)
{
	chomp;
	if(/\schrom=(\S+)/)
	{
		if ($1 ne $lastChr)
		{
			close $oH;
			my $f = $1.'.wig';
			open($oH, '>', $f) or die "cannot write to $f\n";
			$lastChr = $1;
			$predictedPos = 1;
			print $oH "fixedStep chrom=$1 start=1 step=1\n";
			print; print "\n";
		}
		my($vs, $foo, $s) = split(/\s+/);
		die "wrong format: $_\n" if $vs ne 'variableStep';
		if(defined $s)
		{
			$s =~ /^span=(\d+)/ or die;
			$span = $1;
		}
		else
		{
			$span = 1;
		}
	}
	else
	{
		my($pos, $val) = split(/\t/);
		die "$pos != $predictedPos\n" if $predictedPos != $pos;
		print $oH "$val\n" x $span;
		$predictedPos += $span;
	}
}
close $fH;
close $oH;
