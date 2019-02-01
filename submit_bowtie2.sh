#!/bin/bash
#SBATCH -c 8
#SBATCH -N 1
#SBATCH -J aln
#SBATCH -o slurm-%J.mapping.out
#SBATCH -e slurm-%J.mapping.err
#SBATCH --mem 20G
#SBATCH -t 10-0:0:0

# usage: read1, read2, sampleName, assembly, [tempdir]
# Note: chromosomes hardcoded for Zebrafish genome.

set -e

assembly=$4
nCores=$SLURM_CPUS_PER_TASK
if [ -z $5 ]
	then
	mkdir -p /mnt/scratch/piotr/
	tmpDir=$(mktemp /mnt/scratch/piotr/mapping.XXXXXXXXXX --directory)
else
	tmpDir=$5
fi

echoerr() { cat <<< "$@" 1>&2; }

echoerr Using $tmpDir on `hostname`

echoerr Running: submit_bowtie2.sh $1 $2 $3 $4

if [ ! -s $3.$assembly.bowtieStats ]
   then
   echoerr Mapping $3 from $1 and $2
   bowtie2 --maxins 5000 --phred33-quals --threads $nCores -x /mnt/biggles/data/alignment_references/bowtie2/$assembly \
   --no-unal --no-discordant \
   -1 $1 -2 $2 -S $tmpDir/$3.$assembly.sam 2> $3.$assembly.bowtieReport
fi

if [ ! -e $tmpDir/$3.$assembly.bam  ]
   then
   echoerr making bam, filtering for quality...
   samtools view -S -q 10 -@ $nCores -b -u -o $tmpDir/$3.$assembly.bam $tmpDir/$3.$assembly.sam
fi

if [ ! -e $3.$assembly.sorted.bam ]
   then
   echoerr sorting bam...
   samtools sort -l 9 -@ 8 -T $tmpDir/$3.$assembly.tmp -o $3.$assembly.sorted.bam $tmpDir/$3.$assembly.bam
   echoerr indexing bam...
   samtools index $3.$assembly.sorted.bam
fi


if [ ! -e $3.$assembly.goodChr.sorted.bam ] && [ $assembly -eq "danRer7" ]
    then
    echoerr removing scaffolds and chrM...
    samtools view -@ 8 -b -o $3.$assembly.goodChr.sorted.bam $3.$assembly.sorted.bam chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chr23 chr24 chr25
    echoerr indexing bam...
    samtools index $3.$assembly.goodChr.sorted.bam
fi

if [ -e $3.$assembly.goodChr.sorted.bam.bai ] && [ $assembly -eq "danRer7" ]
    then
    echoerr removing temporary files...
    rm --force $tmpDir/$3.$assembly.sam $tmpDir/$3.$assembly.bam
    rmdir $tmpDir
fi

if [ ! -e $3.$assembly.goodChr.sorted.granges.RDS ] && [ $assembly -eq "danRer7" ]
   then
   echoerr creating GRanges...
   sbatch --mem 100G -c 1 -J Granges.$3 ~piotr/bin/bamPe2GRanges.R $3.$assembly.goodChr.sorted.bam $3.$assembly.goodChr.sorted.granges.RDS 1000 $assembly
fi

