#!/import/bc2/soft/app/perl/5.10.1/Linux/bin/perl -w
use strict;

my $f = shift @ARGV;
open(A, $f ) or die;
my $base = shift @ARGV;
my $pseudoc = shift @ARGV or die;

open(B, ">", $f.".log$base") or die;
while(<A>)
{
	chomp;
	my @v = split(/\s/);
	foreach my $v (@v)
	{
		$v = log($v + $pseudoc) / log($base);
	}
	print B join("\t", @v), "\n";
}

close A;
close B;
