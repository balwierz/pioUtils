#!/usr/bin/perl -w

die if @ARGV != 1;
print `grep -i $ARGV[0] /import/bc2/home/zavolan/balwierz/Data/WMs/list_mat_all`;

