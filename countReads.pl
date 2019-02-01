#!/usr/bin/perl -w
use strict;
use Getopt::Long;

# used by pipeline. 

if(!@ARGV)
{
	die "Usage;\n";
}

my $readF = "";
my $regF = "";
my $fivePrime = 0; #whether only the 5' end of a read should be counted
my $sorted = "";  # by default don't use the sweep algorithm, enable to save memory when you know that your files are sorted
my $oF;
my $noZeros = 0;
my $bedToolsPath = '~piotr/Soft/opt/bedtools-2.18.2/bin/';

my $res = GetOptions(
                     "reads=s"  => \$readF,
                     "regions=s" => 	\$regF,
                     "5"	=>	\$fivePrime,
                     "sorted" => \$sorted,
                     "output=s" => \$oF,
                     "no-zeros" => \$noZeros,
                     "bedtools-dir=s" => \$bedToolsPath
                    );

die if !$readF || !$regF;
$sorted = $sorted ? '-sorted' : '';
my $bedtoolsRepFrmt = $noZeros ? '-wo' : '-wao';
if(defined $oF)
{
	close STDOUT;
	open(STDOUT, '>', $oF);
}

# test if files are tab separated (do not contain spaces)
my $test1 = `less '$regF' | head -10 | grep -v "^track"`;
die "$regF contains spaces\nWe need tabs (because of BEDTOOLS)\n" if $test1 =~ / /;
$test1 = `less '$readF' | head -10 | grep -v "^track"`;
die "$readF contains spaces\nWe need tabs (because of BEDTOOLS)\n" if $test1 =~ / /;

# call BedTools and parse the output
open(my $pipeH, "$bedToolsPath/bedtools intersect -b '$readF' -a '$regF' $bedtoolsRepFrmt $sorted |") or die "Cannot call bedtools\n";
my ($lastChr, $lastBeg, $lastEnd, $lastReg, $sum, $lastStr) = ("", 0, 0, "", 0, "+");
for(;;)
{
	$_ = <$pipeH>;
	chomp if $_;
	# usually line looks as follows
	# chr1	3095653	3130463	aaa	0	+	chr1	3130438	3130463	sq16090	0.5	+	25
	my($chr1, $beg1, $end1, $region, $foo1, $str1, $chr2, $beg2, $end2, $read, $weight, $str2, $overlap) =
		split(/\t/, $_ ? $_ : "\t0\t0\t\t0\t+\t.\t-1\t-1\t.\t-1\t.\t0");
	last if ! $_ && ! $lastChr; # this is in case there is an error from bed tools and they produce nothing
	if($lastReg && $region ne $lastReg)
	{
		# write it down;
		if($sum || !$noZeros)
		{
			print join("\t", $lastChr, $lastBeg, $lastEnd, $lastReg, $sum, $lastStr), "\n";
		}
		last if ! $region;
		$sum = 0;
	}
	# check no intereections, eg:
	# chr10	6	10	dupa	0	+	.	-1	-1	.	-1	.	0
	if($chr2 ne '.')
	{
		if($fivePrime )
		{
			# check if the 5' end of the read really overlaps the region
			if(($str2 eq "+" && $beg2 >= $beg1) || ($str2 eq "-" && $end2 <= $end1))
			{
				$sum += $weight;
			}
		}
		else
		{
			$sum += $weight;
		}
	}
	($lastChr, $lastBeg, $lastEnd, $lastReg, $lastStr) =
		($chr1, $beg1, $end1, $region, $str1);
	#sleep 1;
}
close $pipeH;
if(defined $oF)
{
	close (STDOUT);
}
