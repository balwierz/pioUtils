#!/bin/bash
#SBATCH -c 4
#SBATCH -J PEbam-->bw
#SBATCH --mem-per-cpu 6G
#SBATCH -t 1-0
#SBATCH -o slurm.bam2bw-%J.out
#SBATCH -e slurm.bam2bw-%J.err


set -e
bb=`basename $1 .bam`
bb=$(basename $bb .sorted)
bb=$(basename $bb .goodChr)
bb=$(basename $bb .sorted)

if [[ $bb =~ danRer7 ]]
  then
  assemlyLen=/mnt/biggles/data/UCSC/goldenpath/danRer7/chromInfo.sorted.txt
fi

if [[ $bb =~ danRer10 ]]
  then
  assemlyLen=/mnt/biggles/data/UCSC/goldenpath/danRer10/chromInfo.sorted.txt
fi


# as of 2019-06 this does not produce .bdg, but .wig when no format is specified
# and it seds filename given to out s/bdg$/wig/ !
#bam2wig.pl --pos span --pe --rpm --maxsize 500 --in $1 --cpu $SLURM_CPUS_PER_TASK --nogz --out $bb.peSpan.bdg > /dev/null
#LC_ALL=C sort -k1,1 -k2,2n $bb.peSpan.bdg > $bb.peSpan.sorted.bdg
#bedGraphToBigWig $bb.peSpan.sorted.wig $assemlyLen $bb.peSpan.bw

tmpDir=$(mktemp /mnt/scratch/piotr/bam2bigwitPairedendCoverage.XXXXXXXXXX --directory)
bam2wig.pl --pos span --pe --rpm --maxsize 500 --fix --in $1 --cpu $SLURM_CPUS_PER_TASK \
    --nogz --temp $tmpDir --out $bb.peSpan.wig > /dev/null
rmdir $tmpDir
wigToBigWig -clip $bb.peSpan.wig $assemlyLen $bb.peSpan.bw
rm $bb.peSpan.wig


