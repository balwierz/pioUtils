#!/bin/bash
#SBATCH -c 8
#SBATCH -N 1
#SBATCH -J fastQC
#SBATCH -o slurm-%J.fastQC.out
#SBATCH -e slurm-%J.fastQC.err
#SBATCH --mem 5G
#SBATCH -t 1-0:0:0

# usage: read1, read2

nCores=$SLURM_CPUS_PER_TASK

fastqc -o FastQC/ -t $nCores $1 $2
