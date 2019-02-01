#!/bin/bash
#SBATCH -J fixQNAME
#SBATCH --mem 8G
#SBATCH -c 1


# fixes mate names removing .1 and .2 from their QNAME. This allows running readGAlignmentPairs from rtracklayer.
# usage in.bam 

bb=$(basename $1 .bam)


samtools view -h $1 | sed '/^[^@]/s/^\(.*\)\.[12]\t/\1\t/' | samtools view -F 4 -Sb -o $bb.fixQname.bam -
