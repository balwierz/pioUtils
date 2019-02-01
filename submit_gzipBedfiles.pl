#!/usr/bin/perl -w
use strict;

my $dir = shift @ARGV;
opendir(my $dH, $dir) or die;
while(my $f = readdir $dH)
{
	if($f =~ /\.bed$/)
	{
		open(my $testH, "-|", "file", "-b", $dir.'/'.$f) or die;
		my $out = <$testH>;
		close $testH;

		if($out =~ /^gzip compressed data/)
		{
			print STDERR "Renaming $f\n";
			system("mv", $dir.'/'.$f, $dir.'/'.$f.'.gz');
		}
		else
		{
			print STDERR "Gzipping $f\n";
			system("gzip", "-9", $dir.'/'.$f) or die "Cannot compress $dir/$f\n";
		}
	}
}
closedir $dH;

#bed.xz: 15M	//much longer compression; very quick decompression
#bed.gz 33MB
#bed.bz2 34MB	//slower than gz
#bed 154MB
#bam: 27MB
#bed.lzma: 15MB

