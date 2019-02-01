#!/import/bc2/soft/bin/perl5/perl -w
use strict;

die "Usage: proms2fasta.pl promoters=final_level2 upstream=300 downstream=100 genome=hg18\n" unless @ARGV == 4;

my ($promsf, $upstr, $downstr, $genome) = @ARGV;
my $coordsf = "$promsf.$upstr.$downstr.summary";
my $fastaf  = "$promsf.$upstr.$downstr.fa";
my $genomedir = "/import/bc2/data/databases/UCSC/$genome";

open(A, $promsf) or die $!;
die "$coordsf exists!\n" if (-e $coordsf);

my%chrlen;
open(L, "/import/bc2/data/databases/UCSC/".$genome."/".$genome."chrs.tab") or die;
while(<L>)
{
  chomp;
  my($chr, $len) = split(/\s+/);
  $chrlen{$chr} = $len;
}
close L;

open(B, ">$coordsf") or die $!;
while(<A>)
{
  chomp;
  my($id, $chr, $beg, $end, $str) = split(/\s/);
  if($str eq "+")
  {
    $beg -= $upstr;
    $end += $downstr;
  }
  elsif($str eq "-")
  {
    $beg -= $downstr;
    $end += $upstr;
  }
  else
  {
    die "Err\n";
  }
  if($beg <=0) {$beg = 1}
  if($end >= $chrlen{$chr}) { $end = $chrlen{$chr} - 1}
  print B join("\t", $id, $chr, $str, $beg, $end, "0"), "\n";
}
close A;
close B;

print STDERR "Extracting stuff\n";
system("/import/bc2/home/zavolan/GROUP/Perl/PerlScripts/dPerlScripts/extractSeqsFromRegions.pl $coordsf $genomedir > $fastaf");

