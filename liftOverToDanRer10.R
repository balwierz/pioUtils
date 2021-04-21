library(rtracklayer)
library(BSgenome.Drerio.UCSC.danRer10)
install.packages("furrr")
library(furrr)
library(purrr)
plan(multiprocess)

liftover.danRer7ToDanRer10 <- import.chain("/mnt/biggles/data/UCSC/goldenpath/danRer7/liftOver/danRer7ToDanRer10.over.chain")

"GSM1133399_chrall.testis.rescale.bw" %>% 
file <- commandArgs(trailingOnly=T)

list.files(path=".", pattern="\\.rescale\\.bw") %>% future_map(function(f)
{
	foo=import(con=f)
	lo <- liftOver(foo, liftover.danRer7ToDanRer10)
	lo2 <- unlist(lo)
	seqlevels(lo2) = seqlevels(Drerio)
	seqinfo(lo2) = seqinfo(Drerio)

	# liftover is not an injection. you have to allow at most 1 datum per position:	
	hits <- findOverlaps(lo2, lo2)
	lo3 <- sort(lo2[- queryHits(hits)[queryHits(hits) != subjectHits(hits)]])
	
	outF = f %>% sub(pattern="\\.bw", replacement=".danRer10.bw")
	export.bw(object=lo3, con=outF)
})

