#!/import/bc2/soft/bin/perl5/perl -w
use strict;

open(A, shift @ARGV) or die $!;
my @k = <A>;
close(A);

while(@k)
{
  print splice(@k, int(rand(scalar(@k))), 1);
}
