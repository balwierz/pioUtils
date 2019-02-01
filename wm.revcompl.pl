#!/usr/bin/perl -w
use strict;

open(F, shift @ARGV) or die;
my @lines = <F>;
close F;
my @t;
while(my $l = pop @lines)
{
  next if $l =~ /^\/\//;
  chomp $l;
  push @t, $l;
  if($l =~ /^NA\s+(\S+)/)
  {
    print "//\n" , parse(\@t) , "//\n";
    @t=();
  }
}

sub parse
{
  my($lref) = @_;
  #get len;
  my ($len) = split(/\s+/, $$lref[0]);
  my @ret = ();
  push @ret, (pop @$lref) . ".revcmp\n";
  push @ret, (pop @{$lref}) . "\n";
  for(my $i=0; $i<@$lref; $i++)
  {
    if(${$lref}[$i] =~ /^(\d+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)/)
    {
      my $newpos = sprintf("%02d", $len - $1 + 1);
      push @ret, join("\t", $newpos, $5, $4, $3, $2)."\n";
    }
  }
  return @ret;
}



