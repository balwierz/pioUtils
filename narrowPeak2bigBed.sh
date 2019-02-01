#!/bin/bash
# usage: in.narrowPeak out.bb
set -e
# truncate scores at 1000 due to MACS2 bug:
cat $1 | perl -wane 'if($F[4] > 1000) {$F[4]=1000} print join("\t", @F),"\n"' > $1.tmp
bedToBigBed -as=/mnt/biggley/home/piotr/data/narrowPeak.as -type=bed6+4 $1.tmp /mnt/biggles/data/UCSC/goldenpath/danRer7/chromInfo.txt $2
rm $1.tmp
echo track type=bigBed name="" description="" itemRgb="On" bigDataUrl=http://genome.genereg.net
