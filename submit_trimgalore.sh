#!/bin/bash
#SBATCH -c 1
#SBATCH -N 1
#SBATCH -J trim
#SBATCH --mem 5G
#SBATCH -o slurm-%J.trim.out
#SBATCH -e slurm-%J.trim.err

# usage: read1, read2
mkdir -p Out
trim_galore --length 20 --phred33 --paired -o Out -q 20 --fastqc "$@"

