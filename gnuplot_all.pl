#!/usr/bin/perl -w
use strict;

if(not @ARGV) {die "Usage: gnuplot_all.pl n|x|y|xy pattern dir together\n";}

my $log = shift @ARGV;
if(! defined $log)
{
	$log = "n";
}
my $patt = shift @ARGV;
if(! defined $patt)
{
	$patt = "" ;
}
my $dir = shift @ARGV;
if(! defined $dir)
{
	$dir = ".";
}
my $together = shift @ARGV;


open G, "|gnuplot" or die;
print G "set term png\n";
if($log =~ "x")
{
	print G "set log x\n";
}
if($log =~ "y")
{
	print G "set log y\n";
}


if(defined $together)
{
	print G "set output tmp.png\n";
	print G "plot ";
}

opendir D, $dir or die;
while(my $f = readdir D)
{
	if($f =~ $patt)
	{
		print ".";
		if(not defined $together)
		{
			print G "set output '$dir/$f.png'\n";
			print G "plot ";
		}
		print G " '$dir/$f' w l notitle";
		if(not defined $together)
		{
			print G "\n";
		}
		else 
		{
			print G ", ";
		}
	}
}
print "\n";
closedir D;
close G;
