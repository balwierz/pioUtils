#!/usr/bin/Rscript --no-save --no-restore --verbose
#SBATCH -c 1
#SBATCH -N 1
#SBATCH -J bamPe2rnaSeqExonCov
#SBATCH -o slurm.bam2rnaSeqExonCov-%J.out
#SBATCH -e slurm.bam2rnaSeqExonCov-%J.err
#SBATCH --mem 80G
#SBATCH -t 10-0:0:0


args = commandArgs(trailingOnly = TRUE)
#args=c("Tdrd7_Rescue_PGC_rep1_Zv10Aligned.sortedByCoord.out.bam", "Tdrd7_Rescue_PGC_rep1_Zv10Aligned.bw")

if(length(args) < 2 )
{
	stop("bamPe2rnaSeqExonCov.R: usage: infile.bam outfile.bw [assembly]\n")
}

assembly = "danRer10"
if(length(args) >= 3)
{
	assembly = args[[3]]
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


u <- readGAlignmentPairs(file = args[[1]], strandMode=1)  # 1 is strand of teh first read, 2 is of the second
f <- first(u)
l <- last(u)
strand(l) <- strand(f)

g <- GRanges(c(granges(f), granges(l)), seqinfo=seqinfo(refGenome))
export.bw(coverage(g), args[[2]])



# r <- list.files(pattern = ".RDS") %>% 
# 	`names<-`(., str_replace(., ".GRanges.RDS", "")) %>% 
# 	map(readRDS)
# r %>% map(~{seqlevels(.) <- seqlevels(Drerio); seqinfo(.) <- seqinfo(Drerio); .})
# 
# 
# r %>% map(width) %>% map(hist, 100)
# 
# 
