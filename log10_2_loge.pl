#!/usr/bin/perl -w
use strict;

my $scale = log(10);

my($inDir, $outDir) = @ARGV;
`mkdir -p $outDir`;
opendir I, $inDir or die;
while(my $f = readdir I)
{
	if($f =~ /tab$/)
	{
		open O, ">$outDir/$f" or die;
		open F, "$inDir/$f" or die;
		while(<F>)
		{
			chomp;
			print O $_*$scale, "\n";
		}
		close F;
		close O;
	}
}
closedir I;
