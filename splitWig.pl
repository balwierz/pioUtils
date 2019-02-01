#!/mnt/biggles/opt/perl/bin/perl -w
use strict;

# splits wig file by chromosomes
# this is necessery for fseq

open(my $fH, shift @ARGV) or die;
open(my $oH, "/dev/null");
my $lastChr = "";
while(<$fH>)
{
	if(/\schrom=(\S+)\s/)
	{
		if ($1 ne $lastChr)
		{
			close $oH;
			open($oH, '>', $1.'.wig') or die;
			$lastChr = $1;
		}
	}
	print $oH $_;
}
close $fH;
close $oH;
