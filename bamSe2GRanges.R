#!/usr/bin/Rscript --no-save --no-restore
#SBATCH -c 1
#SBATCH -N 1
#SBATCH -J bamSe2Granges
#SBATCH -o slurm.bam2GR-%J.out
#SBATCH -e slurm.bam2GR-%J.err
#SBATCH --mem 80G
#SBATCH -t 1-0:0:0

args = commandArgs(trailingOnly = TRUE)

if(length(args) != 3)
{
	stop("bamSe2GRanges.R: usage: infile.bam outfile.granges.RDS assembly\n")
}

library(rtracklayer, quietly = TRUE, verbose = FALSE, warn.conflicts = FALSE)
library(GenomicAlignments, quietly = TRUE, verbose = FALSE, warn.conflicts = FALSE)
library(GenomicRanges, quietly = TRUE, verbose = FALSE, warn.conflicts = FALSE)
if(assembly == "danRer7")
{
	library("BSgenome.Drerio.UCSC.danRer7")
}
else if(assembly == "danRer10")
{
	library("BSgenome.Drerio.UCSC.danRer10")
}

out = sort(as(object = readGAlignments(file = args[[1]]), Class = "GRanges"))
seqlevels(out) = seqlevels(Drerio)
seqinfo(out) = seqinfo(Drerio)
saveRDS(object=out, file=args[[2]])
#lsos()
