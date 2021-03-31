#!/usr/bin/perl

#$ -S /import/bc2/soft/app/perl/5.10.1/Linux/bin/perl
#$ -P project_zavolan
#$ -q fs_long
#$ -l mem_total=1000M
#$ -o /import/bc2/home/zavolan/balwierz/tmp/gzipdir.out
#$ -e /import/bc2/home/zavolan/balwierz/tmp/gzipdir.err
#$ -j n
#$ -N gzipDir
#$ -cwd

use strict;

opendir(D, ".");
while(my $f = readdir D)
{
	if(-f $f && $f !~ /^\./ && $f !~ /\.gz$/ && $f !~ /\.bz2$/ && $f !~ /\.zip$/)
	{
		print STDERR `gzip -9 $f`;
	}
}
closedir D;
