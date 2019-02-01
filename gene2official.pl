#!/usr/bin/perl -w
use strict;

my %old2new=();
my %uptodate;
open(H, "/import/bc2/home8/zavolan/balwierz/Genes/HUGO_table.txt") or die;
$_=<H>;
while(<H>)
{
  my ($hgnc, $symbol, $name, $status, $locus, $previous, $prevnames, $aliases) = split(/\t/);
  next if $locus eq "pseudogene" or $locus eq "Symbol Withdrawn" or $locus eq "Entry Withdrawn";
  $uptodate{$symbol} = $name;
  foreach my $p  (@{[split(", ", $previous)]}, @{[split(", ", $aliases)]})
  {
    #die "$p defined for $old2new{$p} now $symbol\n" if defined $old2new{$p};
    push @{$old2new{uc $p}}, $symbol;
  }
}
close H;

my $totranslate = shift @ARGV or exit 0;

if(defined $uptodate{$totranslate})
{
  print "$totranslate is good: ".$uptodate{$totranslate}."\n";
}
elsif(defined $old2new{uc $totranslate})
{
  print "Old $totranslate can be now\n";
  foreach my $s (@{$old2new{uc $totranslate}})
  {
    print "$s: $uptodate{$s}\n";
  }
}

