#!/usr/bin/perl -w
use strict;
$|=1;

my $upstrDistCutoff = 300;
my $downstrDistCutoff = 100;


open(my $fH, shift @ARGV) or die;
$_ = <$fH>; # header
@_ = split("\t");
my $i=0;
#my $nMotifs = scalar @_ - 21;
my @motifs = splice(@_, 21); # 21 non-motif columns
@motifs = map {(split /\//)[0]} @motifs;
foreach my $motif (@motifs)
{
	print "\t", $motif;
}
print "\n";

my @promlist;
my %prom2repr;
my %siteSums; #key are promoter, wm
open(my $promH, shift @ARGV) or die $!; # bed file, where score is replaced with representative position
while(<$promH>)
{
	chomp();
	my($chr, $beg, $end, $id, $reprPos, $strand) = split(/\t/);
	if($id eq '.') # no IDs
	{
		$id = $chr . ":" . $beg . '-' . $end;
		if($strand ne '.')
		{
			$id = $id . ":" . $strand;
		}
	}
	push @promlist, $id;
	$prom2repr{$id} = $reprPos;
}


while(<$fH>)
{
	chomp;
	my($id, $chr, $regBeg, $regEnd, $regStr, $regScore, $focus, $anno, $annoDet,
	$annoDist, $refseq, $entrez, $unigene, $refseq2, $ensg, $gname, $galias,
	$gdesc, $gtype, $cpg, $gc, @sites) = split(/\t/);
	for(my $m=0; $m<@sites; $m++)
	{
		next if ! $sites[$m];
		# 499(GACCAATACG,+,0.00),1262(GTCATTGGTT,-,0.00)
		my @thisSites = split(/\),/, $sites[$m]);
		die if ! @thisSites;
		#print "<<".join("|", @thisSites).">>";
		#print " L", scalar @thisSites, "\n";
		@thisSites = map {my @v = split(/[\(\,]/); \@v} @thisSites;
		#print " L", length @thisSites, "\n";
		#print join("_", @thisSites);
		my @sitePos = map {${$_}[0] + $regBeg} @thisSites;
		foreach my $s (@thisSites)
		{
			#print join(" ", @$s);
			my($posWrtReg, $seq, $siteStr, $cons) = @$s;
			my ($upstrDist, $downstrDist);
			if($regStr eq "-")
			{
				$downstrDist = $prom2repr{$id} - $regBeg - $posWrtReg;
				$upstrDist   = -$downstrDist;
			}
			else  # plus strand or unstranded
			{
				$upstrDist   = $prom2repr{$id} - $regBeg - $posWrtReg;
				$downstrDist = -$upstrDist;
			}
			if($upstrDist <= $upstrDistCutoff && $downstrDist <= $downstrDistCutoff)
			{
				$siteSums{$id}->{$motifs[$m]} ++;  # normally here we would write a posterior
			}
		}
		
	}
}
close $fH;

writeMatrix();


sub writeMatrix
{
	foreach my $p (@promlist)
	{
		print $p;
		foreach my $wm (@motifs)
		{
			if(exists $siteSums{$p}->{$wm})
			{
				print "\t", $siteSums{$p}->{$wm};
			}
			else
			{
				print "\t0";
			}
		}
		print "\n";
	}
}
