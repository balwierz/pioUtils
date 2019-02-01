#!/usr/bin/Rscript --no-save --no-restore

args = commandArgs(trailingOnly = TRUE)

if(length(args) != 2)
{
	stop("bamSe2GRanges.R: usage: infile.bam outfile.granges.RDS\n")
}

library(rtracklayer, quietly = TRUE, verbose = FALSE, warn.conflicts = FALSE)
library(GenomicAlignments, quietly = TRUE, verbose = FALSE, warn.conflicts = FALSE)
library(GenomicRanges, quietly = TRUE, verbose = FALSE, warn.conflicts = FALSE)
library("BSgenome.Drerio.UCSC.danRer7")

out = sort(as(object = readGAlignments(file = args[[1]]), Class = "GRanges"))
seqlevels(out) = seqlevels(Drerio)
seqinfo(out) = seqinfo(Drerio)
saveRDS(object=out, file=args[[2]])
lsos()
