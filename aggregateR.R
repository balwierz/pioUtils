#!/usr/bin/Rscript

# a generic script for creating aggregate plots at specific loci
# uses genomation

argv = commandArgs(trailingOnly=TRUE)
# first argument: an R granges object (RDS) with regions
# remaining arguments: alignment objects

regR  = readRDS(file=argv[1])
sampleInd = 2:length(argv)
readR = bplapply(X=argv[sampleInd], FUN=readRDS)
sampleNames = lapply(X=argv[sampleInd], FUN=basename)
libSize = lapply(X=readR, length)

library(genomation, quietly=TRUE)
#library(GenomicRanges, quietly=TRUE)
#library(GenomicAlignments, quietly=TRUE)
#library(gplots, quietly=TRUE)
#library(BSgenome.Drerio.UCSC.danRer7, quietly=TRUE)


smL = ScoreMatrixList( bplapply(X=readR, FUN=function(r) ScoreMatrix(target=r, windows=regR, strand.aware=TRUE, rpm=TRUE, library.size=libSize) ) )


lapply(seq_along(sampleNames), FUN=function(i)
{
	pdf(paste0("agg.", sampleNames[i], ".pdf"))
	plotMeta(mat=smL[[i]], xcoords=c(-2000, 1000), xlab="position wrt TSS", ylab="coverage [#/M]", profile.names=sampleNames[i], dispersion="se")
	dev.off()
	
	pdf(paste0("heat.", sampleNames[i], ".pdf"))
	heatMatrix(mat=smL[[i]], xcoords=c(-2000, 1000))
	dev.off()
}
)
#save.image()


