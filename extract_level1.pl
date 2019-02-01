#!/usr/bin/perl -w
use strict;
use List::Util qw(sum);

my($file, $dchr, $dstr, $dfrom, $dto) = @ARGV;
if ($file eq "hg")
{
	$file = "/import/bc2/home/nimwegen/GROUP/GNP/AllCAGE14Dec2007/proms_level1_human_filtered.norm_and_raw";
}
elsif($file eq "mm")
{
	die; #todo
}
if(not defined $dto)
{
	die "usage: extract_level1.pl hg chr19 + 482678 482777\n";
}

open(F, $file) or die;
my $results;
while(<F>)
{
	chomp;
	my($chr, $str, $pos, @rest) = split(/\t/);
	if($chr eq $dchr and $str eq $dstr and $dfrom <= $pos and $pos <= $dto)
	{
		my @normalized = splice(@rest, 0, @rest/2);
		#print "size: ", scalar @normalized, "\n";
		$results->{$pos}->{sum} = sum(@normalized);
		$results->{$pos}->{var} = var(\@normalized);
	}
}
close F;

my @ordered = sort {$a <=> $b} keys %{$results};

my $imin = $ordered[0];
my $imax = $ordered[-1];

for(my $i=$imin; $i<=$imax; $i++)
{
	if(not exists $results->{$i})
	{
		print "$i\t0\t0\n";
	}
	else
	{
		print join("\t", $i, $results->{$i}->{sum}, $results->{$i}->{var}), "\n";
	}
}


sub var
{
	my ($k)=@_;
	my $r = 0;
	my $w = 0;
	foreach my $u (@{$k})
	{
		$r += $u**2;
		$w += $u;
	}
	$w /= @{$k};
	return $r/@{$k} - $w**2;
}
