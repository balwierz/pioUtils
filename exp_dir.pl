#!/usr/bin/perl -w
use strict;

my($inDir, $outDir, $base, $patt) = @ARGV;
`mkdir -p $outDir`;
opendir I, $inDir or die;
while(my $f = readdir I)
{
	if($f =~ $patt)
	{
		open O, ">$outDir/$f" or die;
		open F, "$inDir/$f" or die;
		while(<F>)
		{
			chomp;
			print O $base**$_, "\n";
		}
		close F;
		close O;
	}
}
closedir I;
