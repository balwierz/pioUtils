#!/usr/bin/perl -w
use strict;

my %h=('A' => 'T', 'C' => 'G', 'G' => 'C', 'T' => 'A', 'N' => 'N');

# no brackets just for fun!!
print join "", map {$h{$_}} reverse split "", uc shift @ARGV;
print"\n"

