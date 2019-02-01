#!/bin/bash
#SBATCH -c 4
#SBATCH -N 1
#SBATCH -J ATAC_tracks
#SBATCH --mem 10G


# converts sam/bam file to ATAC tracks based on fragment size.
# requires a sorted sam/bam as input 

# usage sbatch submit_splitSam.sh sam/bam_file stub

if [ -z "$2" ]
then
	echo "Usage: file.bam stub genome
		  eg. foo.bam ATAC.celltype.rep1.Piotr.2017-05 danRer10"
	exit 1
fi

set -e

pair1=40,120
pair2=165,250
pair3=330,5000

assemblyLen="/mnt/biggles/data/UCSC/goldenpath/$3/chromInfo.sorted.txt"

if [ ! -e "$assemblyLen" ]
then
	echo "Assembly index not found in $assemblyLen"
	exit 1
fi

stub="$2.$3"

# in case it is run outside of slurm:
if [ -z $SLURM_CPUS_PER_TASK ]
then
    SLURM_CPUS_PER_TASK=4
fi

echo splitting $1
~piotr/bin/splitPeSamAccordingToInsertSize.pl $1 $stub $pair1 $pair2 $pair3


for pair in $pair1 $pair2 $pair3
do
    echo converting sam to bam: $pair
    samtools view -@ $SLURM_CPUS_PER_TASK -S -b $stub.$pair > $stub.$pair.bam && rm $stub.$pair
    samtools sort -l 9 -@ $SLURM_CPUS_PER_TASK -m 2G -o $stub.$pair.sorted.bam $stub.$pair.bam 
    samtools index $stub.$pair.sorted.bam

    echo creating WIG tracks: $pair
    bam2wig.pl --pos span --pe --rpm --in $stub.$pair.sorted.bam --cpu $SLURM_CPUS_PER_TASK --nogz --out $stub.$pair.peSpan.bdg > /dev/null
    LC_ALL=C sort -k1,1 -k2,2n $stub.$pair.peSpan.bdg > $stub.$pair.peSpan.sorted.bdg
    bedGraphToBigWig $stub.$pair.peSpan.sorted.bdg $assemblyLen $stub.$pair.peSpan.bw
    rm $stub.$pair.peSpan.bdg $stub.$pair.peSpan.sorted.bdg
    rm $stub.$pair.bam
done
