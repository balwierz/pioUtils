#!/usr/bin/Rscript --no-save --no-restore
#SBATCH -c 1
#SBATCH -N 1
#SBATCH -J bamPe2Granges
#SBATCH -o slurm.bam2GR-%J.out
#SBATCH -e slurm.bam2GR-%J.err
#SBATCH --mem 80G
#SBATCH -t 10-0:0:0

args = commandArgs(trailingOnly = TRUE)

if(length(args) < 2 )
{
	stop("bamPe2GRanges.R: usage: infile.bam outfile.granges.RDS [maxFragSize] [assembly]\n")
}

assembly = "danRer7"
if(length(args) >= 4)
{
	assembly = args[[4]]
}

suppressWarnings(library(rtracklayer, quietly = TRUE, verbose = FALSE, warn.conflicts = FALSE))
suppressWarnings(library(GenomicAlignments, quietly = TRUE, verbose = FALSE, warn.conflicts = FALSE))
suppressWarnings(library(GenomicRanges, quietly = TRUE, verbose = FALSE, warn.conflicts = FALSE))

# no, you cannot just paste BSgenome... and assembly to form a string. R is shit.
if(assembly == "danRer10")
{
	suppressWarnings(library("BSgenome.Drerio.UCSC.danRer10"))
}
if(assembly == "danRer7")
{
	suppressWarnings(library("BSgenome.Drerio.UCSC.danRer7"))
}


# read alignments from BAM (slow):
out = readGAlignmentPairs(file = args[[1]])

# filter out pairs across different chromosomes. Given mapping parameters to bowtie2 (no discordant), such
# pairs should not exist. But they do.
out = out[seqnames(out@first) == seqnames(out@last)]

# convert to GRanges:
out = sort(as(object = out, Class = "GRanges"))

# assign genome information:
#seqlevels(out, pruning.mode="coarse") = seqlevels(Drerio)
#seqinfo(out)   = seqinfo(Drerio)
#genome(out)    = genome(Drerio)

if(length(args) >= 3 )
{
	maxFragSize = as.integer(args[[3]])
	out = out[width(out) <= maxFragSize]
}

saveRDS(object=out, file=args[[2]])
#lsos()
