#!/usr/bin/perl -w
use strict;

my $FILE = shift @ARGV;
if(defined $FILE)
{
	open(STDIN, $FILE) or die;
}
my @tab = ();
while(<STDIN>)
{
	chomp;
	local $^W = 0;
	if($_ ne '0' && $_ == 0)
	{
		print STDERR "skipping not data: $_\n";
		next;
	}
	push @tab, $_;
}
close(STDIN);

my $y = 1;
my $n = scalar @tab;
@tab = sort {$a <=> $b} @tab;
my $lastval = -3.52923756295872957883;
my $lastplateau = 1.0;
for(my $i=0; $i<$n; $i++)
{
	if($tab[$i] != $lastval)
	{
		if($i)
		{
			print $tab[$i], "\t", $lastplateau, "\n";
		}
	  print $tab[$i], "\t", 1-$i/$n, "\n";
	  #print "dupa", "\n";
	  $lastplateau = 1-$i/$n;
	  $lastval = $tab[$i];
	}

	
}
#print $tab[$n-1], "\t", 0, "\n";

