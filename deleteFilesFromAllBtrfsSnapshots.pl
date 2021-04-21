#!/usr/bin/perl
use strict;

my $dir = "/mnt/storage/.snapshots";
my $filesToDeleteF = shift @ARGV or die;
open(F, $filesToDeleteF) or die;
my @filesToDelete  = <F>;
close(F);

opendir(D, $dir) or die;
my @snapshots = readdir D;
foreach my $snapshot (@snapshots)
{
    next if $snapshot =~ /^\.\.?$/;
    print "read-write\n";
    system('btrfs', 'property', 'set', '-ts', "$dir/$snapshot/snapshot", 'ro', 'false');
    print "entering snapshot $snapshot\n";
    foreach my $f (@filesToDelete)
    {
    	chomp $f;
    	$f =~ s/^\/mnt\/storage\///;
    	system('rm', '-f', "$dir/$snapshot/snapshot/$f");
    }
    system('btrfs', 'property', 'set', '-ts', "$dir/$snapshot/snapshot", 'ro', 'true');
    print "read-only\n";
}
closedir(D);
