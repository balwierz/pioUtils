#!/usr/bin/perl -w
use strict;

#does not work with negative values!!!

my $FILE = shift @ARGV;
if(defined $FILE)
{
	open(STDIN, $FILE) or die "Cannot open $FILE\n";
}
my @tab = ();

while(<STDIN>)
{
	chomp;
	local $^W = 0;
	next if $_ =~ /^#/;
	if($_ ne '0' && $_ == 0)
	{
		print STDERR "skipping not data: $_\n";
		next;
	}
	push @tab, $_;
}
close(STDIN);

my $n = scalar @tab;
@tab = sort {$a <=> $b} @tab;
my $lastval = -3.52923756295872957883;
my $lastplateau = $n;
for(my $i=0; $i<$n; $i++)
{
	if($tab[$i] != $lastval)
	{
		if($i)
		{
			print $tab[$i], "\t", $lastplateau, "\n";
		}
	  print $tab[$i], "\t", $n-$i, "\n";
	  $lastplateau = $n-$i;
	  $lastval = $tab[$i];
	}
}
#print $tab[$n-1], "\t", 0, "\n";

