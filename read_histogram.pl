#!/usr/bin/perl -w
use strict;
use File::Temp qw/ tempfile tempdir /;

# creates a histogram of read centers using bed tools
# - can accept gzipped bed files automagically!!
# - need to specify shifted reads already
# - ignores strand of a read, but not the one from the region


my($regionsF, $readsF, $assembly) = @ARGV;
my $winSize = 2000;
my $sigma = 10;
my $totalsF = "totals.txt"; # if exists profiles will be normalized
my %allRegions;
my %profile;
my $bedToolsExe = "~piotr/Soft/opt/bedtools-2.18.2/bin/bedtools";
my $chrLenF = "/gbdb/$assembly/chromInfo.txt";

# extend the regions by $winSize because they can be smaller:
my ($tmpH, $tmpF) = tempfile();
open(my $pipe, "-|", "$bedToolsExe slop -g '$chrLenF' -i '$regionsF' -b $winSize") or die;
while(<$pipe>)
{
	print $tmpH $_;
}
close $pipe;
close $tmpH;

# the actual intersection:
open(B, "-|", "$bedToolsExe intersect -wao -b '$readsF' -a '$tmpF'") or die "Can't execute bedtools\n";
while(<B>)
{
	chomp;
	my($chr1, $regBeg, $regEnd, $regName, $regScore, $regStrand, $readChr, $readBeg, $readEnd, $readName, $readScore, $readStrand, $overlap) = split(/\t/);
	$allRegions{$regName} = 1;
	if($readChr ne "." && $readStrand eq "+")
	{
		my $read5prim = $readStrand eq "+" ? $readBeg : $readEnd;
		my $regCentre = int($regEnd - $regBeg);
		my $dist = $regStrand eq "+" ? $read5prim - $regCentre : -$read5prim + $regCentre;
		$profile{$dist} ++; #yes, it does not need to be initialized
	}
}
close B;

my $nRegions = scalar keys %allRegions;


# smooth the profile;
my %kernel;
my $z = 0;
for(my $i=-3*$sigma; $i<=3*$sigma; $i++)
{
	my $val = exp(-($i)**2/(2*$sigma**2));
	$z += $val;
	$kernel{$i} = $val;
}
for(my $i=-3*$sigma; $i<=3*$sigma; $i++)
{
	$kernel{$i} /= $z;
}
my %smoothProf;
for(my $j=-$winSize-3*$sigma; $j<=$winSize+3*$sigma; $j++)
{
	if ( ! exists $profile{$j} )
		{ $profile{$j} = 0 }
}
for(my $j=-$winSize; $j<=$winSize; $j++)
{
	for(my $i=-3*$sigma; $i<=3*$sigma; $i++)
	{
		$smoothProf{$j} += $profile{$j+$i}/$nRegions * $kernel{$i};
	}
}

my %sample2tot;
if(-e $totalsF)
{
	open(my $tH, $totalsF) or die;
	while(<$tH>)
	{
		chomp;
		my ($sample, $tot) = split(/\t/);
		$sample2tot{$sample} = $tot;
	}
	close $tH;
}

my ($sample) = split(/\./, $readsF);
my $tot = $sample2tot{$sample};
 
foreach my $dist (-$winSize..$winSize) # (sort {$a<=>$b} keys %profile)
{

	print $dist, "\t", $profile{$dist}, "\t",
		# $profile{$dist}/$nRegions,
		"\t", $smoothProf{$dist},
		 "\n";
}
