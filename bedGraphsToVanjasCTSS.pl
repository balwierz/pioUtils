#!/usr/bin/perl -w
use strict;

# get all files:
opendir(D, '.') or die;
my @files = grep {/\.CTSS\.raw\.plus\.bedGraph$/}readdir D;
closedir D;

#print join("\n", @files);

foreach my $f (@files)
{
	my $sampleID = $f;
	$sampleID =~ s/\.CTSS\.raw\.plus\.bedGraph//;
	open(my $rpH, $f) or die;
	open(my $rmH, $sampleID.'.CTSS.raw.minus.bedGraph') or die;
	open(my $npH, $sampleID.'.CTSS.normalized.plus.bedGraph') or die;
	open(my $nmH, $sampleID.'.CTSS.normalized.minus.bedGraph') or die;
	$_ = <$rpH>; $_ = <$rmH>; $_ = <$npH>; $_ = <$nmH>;
	open(my $wH, '>', $sampleID.".CTSS.bed") or die;
	while(<$rpH>)
	{
		chomp;
		my ($chr, $beg, $end, $raw) = split(/\t/);
		my $foo = <$npH>; chomp $foo;
		my ($chr2, $beg2, $end2, $norm) = split(/\t/, $foo);
		die $_ . $foo if (($chr ne $chr2) || ($beg != $beg2) || ($end != $end2));
		print $wH join("\t", $chr, $end, $end, '.', '-1', '+', $raw, $norm), "\n";
	}
	while(<$rmH>)
	{
		chomp;
		my ($chr, $beg, $end, $raw) = split(/\t/);
		$_ = <$nmH>; chomp;
		my ($chr2, $beg2, $end2, $norm) = split(/\t/);
		die if ($chr ne $chr2 || $beg != $beg2 || $end != $end2);
		print $wH join("\t", $chr, $end, $end, '.', '-1', '-', abs($raw), abs($norm)), "\n";
	}
	close $rpH; close $rmH; close $npH; close $nmH; close $wH;
}

#CTSS.raw.plus.bedGraph
