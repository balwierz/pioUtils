#!/mnt/biggles/opt/perl/bin/perl -w
use strict;
use PerlIO::gzip;

# script to split gzipped fasta files from UCSC's bigZips directory
# to a new directory with single file per contig/chromosome
# such a split is necessery to quickly (or quicker) extract sequences
# without bsGenome


my ($fastaF, $outD) = @ARGV;
if($fastaF =~ /\.gz/)
{
	open F, "<:gzip", $fastaF or die $!;
}
else
{
	open F, $fastaF or die $!
}
mkdir $outD;
my $outH;
open $outH, "/dev/null"; # dummy
while (<F>)
{
	if(/^>(.+)/)  # well, if there are spaces in the contig names we just include them in the file name
	{
		close $outH;
		chomp $1;
		open $outH, '>', "$outD/$1.fa" or die;
	}
	else
	{
		print $outH $_
	}
}

close F;
