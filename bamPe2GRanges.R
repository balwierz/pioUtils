#!/usr/bin/Rscript --no-save --no-restore --verbose
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

assembly = "danRer10"
if(length(args) >= 4)
{
	assembly = args[[4]]
}

suppressMessages(library(rtracklayer, quietly = TRUE, verbose = FALSE, warn.conflicts = FALSE))
suppressMessages(library(GenomicAlignments, quietly = TRUE, verbose = FALSE, warn.conflicts = FALSE))
suppressMessages(library(GenomicRanges, quietly = TRUE, verbose = FALSE, warn.conflicts = FALSE))

# no, you cannot just paste BSgenome... and assembly to form a string. R is shit.
if(assembly == "danRer10")
{
	suppressMessages(library("BSgenome.Drerio.UCSC.danRer10"))
	refGenome = Drerio
}
if(assembly == "danRer7")
{
	suppressMessages(library("BSgenome.Drerio.UCSC.danRer7"))
	refGenome = Drerio
}
if(assembly == "mm9")
{
	suppressMessages(library("BSgenome.Mmusculus.UCSC.mm9"))
	refGenome = Mmusculus
}
if(assembly == "hg19")
{
	suppressMessages(library("BSgenome.Hsapiens.UCSC.hg19"))
	refGenome = Hsapiens
}


# read alignments from BAM (slow):
cat("reading\n")
out = readGAlignmentPairs(file = args[[1]], strandMode=0)

# filter out pairs across different chromosomes. Given mapping parameters to bowtie2 (no discordant), such
# pairs should not exist. But they do.
cat("pair filtering\n")
out = out[seqnames(out@first) == seqnames(out@last)]

# convert to GRanges:
cat("converting\n")
out = sort(as(object = out, Class = "GRanges"))

cat("adding genome\n")
# assign genome information:
seqlevels(out) = seqlevels(refGenome)
seqinfo(out)   = seqinfo(refGenome)
genome(out)    = genome(refGenome)

if(length(args) >= 3 )
{
	cat("size filtering\n")
	maxFragSize = as.integer(args[[3]])
	out = out[width(out) <= maxFragSize]
}
cat("saving\n")
saveRDS(object=out, file=args[[2]])
#lsos()
