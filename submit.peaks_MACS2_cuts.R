#!/usr/bin/Rscript
#SBATCH -J MACS2_cuts
#SBATCH --mem 40G

suppressMessages(
	{
		library(GenomicRanges)
		library(BayesPeak)
		library(rtracklayer)
	})

# usage: sbatch -a 1-n submit.peaks_MACS2_cuts.R input.files.txt outDir [genome]
#
#	input.files.txt has a form
#	/path/to/sample1.RDS	sample1

assembly = "danRer7"
argv = commandArgs(trailingOnly=T)
outdir = paste0(argv[2], "/")  #just in case
if(length(argv) >= 3)
{
	assembly = argv[3]
}
if(assembly == "danRer10")
{
	suppressMessages(library("BSgenome.Drerio.UCSC.danRer10"))
	refGenome = Drerio
	nuclearChr = GRanges(names(seqlengths(refGenome))[1:25], IRanges(1, seqlengths(refGenome)[1:25]))
	refGenomeLen = 1.412e9
	chromInfo = '/mnt/biggles/data/UCSC/goldenpath/danRer10/chromInfo.txt'
}
if(assembly == "danRer7")
{
	suppressMessages(library("BSgenome.Drerio.UCSC.danRer7"))
	refGenome = Drerio
	nuclearChr = GRanges(names(seqlengths(refGenome))[1:25], IRanges(1, seqlengths(refGenome)[1:25]))
	refGenomeLen = 1.412e9
	chromInfo = '/mnt/biggles/data/UCSC/goldenpath/danRer7/chromInfo.txt'
}
if(assembly == "mm9")
{
	suppressMessages(library("BSgenome.Mmusculus.UCSC.mm9"))
	refGenome = Mmusculus
	nuclearChr = GRanges(seqnames(Mmusculus)[seqnames(Mmusculus) != "chrM"], IRanges(1, seqlengths(refGenome)[seqnames(Mmusculus) != "chrM"]))
	refGenomeLen = 2.726e+09
	chromInfo = '/mnt/biggles/data/UCSC/goldenpath/mm9/chromInfo.txt'
}

input = read.delim(file=argv[1], header=F, sep="\t", stringsAsFactors=FALSE)
names(input) = c("f", "sampleName")

taskID = as.integer(Sys.getenv("SLURM_ARRAY_TASK_ID"))
sample=input$sampleName[taskID]
system2('mkdir', c('-p', outdir))
#dir.create(outdir)
bedCutF = paste0(outdir, "ATAC_cuts50_", sample, ".bed")

if(T)
{
	# get cut sites:
	atacR = readRDS(input$f[taskID])
	atacR = subsetByOverlaps(atacR, nuclearChr)
	cut0 = GRanges(seqnames(atacR), IRanges(start(atacR)+5-25, start(atacR)+5+25))
	cut1 = GRanges(seqnames(atacR), IRanges(end(atacR)-4-25, end(atacR)-4+25))
	a = sort(c(cut0, cut1))
	
	seqlevels(a) = seqlevels(refGenome)
	seqinfo(a)   = seqinfo(refGenome)
	a = trim(a)
	strand(a) = "+"
	export.bed(a, bedCutF)
	
	# run MACS2
	system2('macs2', args=c('callpeak', '-t', bedCutF, '-f', 'BED', '-g', refGenomeLen,
							'--keep-dup', 'all', '--nolambda', '--nomodel', '-n', paste0('ATAC.', sample, '.cuts50'), '-B',
							'--outdir', outdir))
	
	
	#cat Results/MACS2_cuts/ATAC.30pEpi.cuts.chr11_peaks.narrowPeak | perl -wane '$F[6] = $F[6] > 1000 ? 1000 : int($F[6]); print join "\t", @F[0,1,2,3,6,5], "\n"' > ATAC.30pEpi.cuts.chr11_peaks.bed
	
}

# correct off-chromosome peaks:
a = read.table(paste0(outdir, 'ATAC.', sample, '.cuts50', "_peaks.narrowPeak"))
colnames(a) = c("seqnames", "start", "end", "name", "foo", "strand", "enrichment", "mLog10pval", "mLog10qval", "summit")
a$start = a$start+1
a$score = pmin(as.integer(a$enrichment), 1000)
a = as(a, "GRanges")
seqlevels(a) = seqlevels(refGenome)
seqinfo(a)   = seqinfo(refGenome)
a = trim(a)

if(T)
{
	export.bed(a, paste0(outdir, "ATAC.", sample, ".cuts50", ".bed"))
	system2('bedToBigBed', c(
		'-type=bed6', paste0(outdir, "ATAC.", sample, ".cuts50", ".bed"),
		chromInfo,
		paste0(outdir, "ATAC.", sample, ".cuts50", ".bb")))
	
	export.bed(a[a$enrichment >= 4], paste0(outdir, "ATAC.", sample, ".cuts50_enr4", ".bed"))
	system2('bedToBigBed', c(
		'-type=bed6', paste0(outdir, "ATAC.", sample, ".cuts50_enr4", ".bed"),
		chromInfo,
		paste0(outdir, "ATAC.", sample, ".cuts50_enr4", ".bb")))

	export.bed(a[a$enrichment >= 10], paste0(outdir, "ATAC.", sample, ".cuts50_enr10", ".bed"))
	system2('bedToBigBed', c(
		'-type=bed6', paste0(outdir, "ATAC.", sample, ".cuts50_enr10", ".bed"),
		chromInfo,
		paste0(outdir, "ATAC.", sample, ".cuts50_enr10", ".bb")))
}
