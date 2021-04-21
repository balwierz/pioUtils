#!/usr/bin/perl -w
use strict;

my $stub = shift @ARGV or die;

# nfrpos:
system("gunzip", "--keep", "-f", $stub.".nucleoatac.nfrpos.bed.gz");
system("cut -f 1-3 $stub.nucleoatac.nfrpos.bed > $stub.nucleoatac.nfrpos.bed3");
system("bedToBigBed", "-type=bed3", $stub.".nucleoatac.nfrpos.bed3",
    '/mnt/biggles/data/UCSC/goldenpath/danRer10/chromInfo.txt',
    "$stub.nucleoatac.nfrpos.bb");

# nucleosome dyads positions:
system("gunzip", "--keep", "-f", $stub.".nucleoatac.nucpos.bed.gz");
system("cut -f 1-3 $stub.nucleoatac.nucpos.bed > $stub.nucleoatac.nucpos.bed3");
system("bedToBigBed", "-type=bed3", $stub.".nucleoatac.nucpos.bed3", 
    '/mnt/biggles/data/UCSC/goldenpath/danRer10/chromInfo.txt',
    "$stub.nucleoatac.nucpos.bb");


#zcat 0001AS.DCD000394SQ.nucleoatac.nucpos.bed.gz | head
#chr1	126690	126691	3.556755611272222	0.2331226403201475	0.04146280833069453	0.5218064452745679	2.1924623516290147	0.5601719148336212	0.8212846748903624	2.0	6.0	22.77928767066044


#0001AS.DCD000394SQ.nucleoatac.nfrpos.bed.gz | head
#chr1	127177	127586	0.06505590570566905	0.03812936602982524	0.4132029339853301	1.0967452130612696
