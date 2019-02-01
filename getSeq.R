#!/usr/bin/env Rscript
##!/mnt/biggles/opt/R/R-3.1.1-panda/bin/Rscript

# usage: getSeq.R Zv9 coords.bed

.loadGenome = function(genome)
{
    require(genome, character.only=TRUE)
    genome.name = unlist(strsplit(genome, split='\\.'))
    return(get(genome.name[2]))
}

args = commandArgs(trailingOnly=TRUE)
genomeToLoad = switch(args[1], # genome
	hg19 = "BSgenome.Hsapiens.UCSC.hg19",
	mm9  = "BSgenome.Mmusculus.UCSC.mm9",
	mm10 = "BSgenome.Mmusculus.UCSC.mm10",
	Zv9  = "BSgenome.Drerio.UCSC.danRer7",
	danRer7 = 'BSgenome.Drerio.UCSC.danRer7'
)
bsgenome = .loadGenome(genomeToLoad)

#library(BSgenome.Hsapiens.UCSC.hg19)
#library(BSgenome.Mmusculus.UCSC.mm9)

#bsgenome = switch(args[1], # genome
#	hg19 = Hsapiens,
#	mm9  = Mmusculus
#)
# read the bed file:

foo = read.table(args[2])
gR  = GRanges(seqnames=foo[,1], ranges=IRanges(start=foo[,2], end=foo[,3]))
seqs = getSeq(bsgenome, gR)
names(seqs) = foo[,4]
writeXStringSet(seqs, paste(args[2], 'fa', sep='.'), width=20000)


