#!/bin/bash
#SBATCH --array=0-4
#SBATCH -c 16
#SBATCH -J Tophat
#SBATCH -p low
#SBATCH --mem 15G

args=("$@")
f=${args[$SLURM_ARRAY_TASK_ID]}

echo "Working on $f"
fastq-dump $f
f=$(basename $f .sra)

tophat --library-type=fr-unstranded \
	--splice-mismatches=1 \
	--max-multihits=100 \
	--num-threads $SLURM_CPUS_PER_TASK \
	--output-dir Tophat.$f \
	/mnt/biggles/data/alignment_references/bowtie2/danRer7 \
	$f.fastq
