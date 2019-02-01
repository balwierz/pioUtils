#!/bin/bash
#SBATCH -c 4
#SBATCH -J PEbam-->bw
#SBATCH --mem-per-cpu 6G
#SBATCH -t 1-0

bb=`basename $1 .bam`
assemlyLen=/mnt/biggles/data/UCSC/goldenpath/danRer7/chromInfo.sorted.txt


bam2wig.pl --pos span --pe --rpm --max_isize 500 --in $1 --cpu $SLURM_CPUS_PER_TASK --nogz --out $bb.peSpan.bdg > /dev/null
LC_ALL=C sort -k1,1 -k2,2n $bb.peSpan.bdg > $bb.peSpan.sorted.bdg
bedGraphToBigWig $bb.peSpan.sorted.bdg $assemlyLen $bb.peSpan.bw
rm $bb.peSpan.bdg $bb.peSpan.sorted.bdg


