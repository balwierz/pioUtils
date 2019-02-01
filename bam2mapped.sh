#!/bin/bash

samtools idxstats $1 | cut -f 3 | perl -we 'my $i=0; while(<>){$i+=$_} print $i."\n"'
