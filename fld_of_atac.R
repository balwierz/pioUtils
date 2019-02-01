#!/usr/bin/Rscript --no-save --no-restore
#SBATCH -c 1
#SBATCH -N 1
#SBATCH -J fld_of_atac
#SBATCH -o slurm-%J.fld.out
#SBATCH -e slurm-%J.fld.err
#SBATCH --mem 20G
#SBATCH -t 1-0:0:0

# usage: sbatch fld_of_atac.R sample.RDS sampleName.danRerX

#library(IdeoViz)
library(BiocParallel)
#library(BSgenome.Drerio.UCSC.danRer7)
#require(RColorBrewer)
library(minpack.lm)
library(GenomicRanges)

args = commandArgs(trailingOnly = TRUE)
data = readRDS(args[[1]])
sampleName = args[[2]]

processRegion = function(data, dir, name)
{
	data2 = table(width(data))
	fragLen = as.numeric(names(data2))
	fragCnt = data2
	fragCnt = fragCnt[fragLen >= 50]
	fragCnt = fragCnt / sum(fragCnt)
	fragLen = fragLen[fragLen >= 50]
	fit.ls = nlsLM(fragCnt ~ a1*exp(-b*fragLen) + a2*exp(-b2*fragLen) + c1*exp(-(fragLen-s)^2/e1) + c2*exp(-(fragLen-s-w)^2/e1) + c3*exp(-(fragLen-s-2*w)^2/e1), start=list(a1=0.02, a2=0.001, b=0.024, b2=0.003, c1=0.002, c2=0.001, c3=0.0005, e1=1800, s=212, w=185),
					  control = list(maxiter = 500, warnOnly = T),
					  lower=c(a1=0, a2=0, b=0, b2=0, c1=0, c2=0, c3=0, e1=20, s=100, w=100), algorithm="port" );
	xx = seq(50,800)
	fitCurve = data.frame(fragLen = xx);
	png(paste0(dir, "/", name, ".fld.png"), width=1000, height=800)
	plot(fragLen, fragCnt, log="", type='l', xlim=c(40,800), xlab="fragment size [bp]", ylab="PET count",
		#main=formula(fit.ls), cex.main=0.5,
		main = name,
		lwd=2)
		
	lines(xx, predict(fit.ls, newdata=fitCurve), col="red");
	coeffs=summary(fit.ls)$coefficients
	lines(xx, coeffs["a1", 1] * exp(-coeffs["b", 1]*xx), col="blue");
	lines(xx, coeffs["a2", 1] * exp(-coeffs["b2", 1]*xx), col="green");
	lines(xx, coeffs["c1", 1] * exp(-(xx-coeffs["s", 1])^2/coeffs["e1", 1]) 
		  + coeffs["c2", 1]*exp(-(xx-coeffs["s", 1]-coeffs["w",1])^2/coeffs["e1", 1])
		  + coeffs["c3", 1]*exp(-(xx-coeffs["s", 1]-2*coeffs["w",1])^2/coeffs["e1", 1]), col="purple");
	grid()
	dev.off()
	write.table(coeffs, paste0(dir, "/", name, ".fld.fit.tab"), sep="\t", quote=F)

	
	fit.ls
}

processRegion(data, ".", sampleName)

#~ ww1k256H = bplapply(seq_along(tiles), function(i)
#~ {
#~ 	#cat(i)
#~ 	data2 = table(width(subsetByOverlaps(data, tiles256H[i])))
#~ 	fragLen = as.numeric(names(data2))
#~ 	fragCnt = data2
#~ 	fragCnt = fragCnt[fragLen >= 50]
#~ 	fragCnt = fragCnt / sum(fragCnt)
#~ 	fragLen = fragLen[fragLen >= 50]
#~ 	fit.ls = nlsLM(fragCnt ~ a1*exp(-b*fragLen) + a2*exp(-b2*fragLen) + c1*exp(-(fragLen-s)^2/e1) + c2*exp(-(fragLen-s-w)^2/e1) + c3*exp(-(fragLen-s-2*w)^2/e1), start=list(a1=0.02, a2=0.001, b=0.024, b2=0.003, c1=0.002, c2=0.001, c3=0.0005, e1=1800, s=212, w=185),
#~ 				  control = list(maxiter = 500, warnOnly = T),
#~ 				  lower=c(a1=0, a2=0, b=0, b2=0, c1=0, c2=0, c3=0, e1=20, s=100, w=100), algorithm="port" );
#~ 	xx = seq(50,800)
#~ 	fitCurve = data.frame(fragLen = xx);
#~ 	png(paste0("Plots/FragLenHist/s256cH/1Mb/", as.character(tiles[i]), ".png"), width=1000, height=800)
#~ 	plot(fragLen, fragCnt, log="", type='l', xlim=c(40,800), xlab="fragment size", ylab="PET count", main=formula(fit.ls), cex.main=0.5, lwd=2)
#~ 	lines(xx, predict(fit.ls, newdata=fitCurve), col="red");
#~ 	coeffs=summary(fit.ls)$coefficients
#~ 	lines(xx, coeffs["a1", 1] * exp(-coeffs["b", 1]*xx), col="blue");
#~ 	lines(xx, coeffs["a2", 1] * exp(-coeffs["b2", 1]*xx), col="green");
#~ 	lines(xx, coeffs["c1", 1] * exp(-(xx-coeffs["s", 1])^2/coeffs["e1", 1]) 
#~ 		  + coeffs["c2", 1]*exp(-(xx-coeffs["s", 1]-coeffs["w",1])^2/coeffs["e1", 1])
#~ 		  + coeffs["c3", 1]*exp(-(xx-coeffs["s", 1]-2*coeffs["w",1])^2/coeffs["e1", 1]), col="purple");
#~ 	grid()
#~ 	dev.off()
#~ 	#summary(fit.ls)$coefficients["w", ]
#~ 	fit.ls
#~ })
#~ tiles256H$ww = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["w", 1]))
#~ tiles256H$up = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["w", 1]+summary(x)$coefficients["w", 2]))
#~ tiles256H$down = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["w", 1]-summary(x)$coefficients["w", 2]))
#~ tiles256H$b  = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["b", 1]))
#~ tiles256H$b_up  = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["b", 1] + summary(x)$coefficients["b", 2]))
#~ tiles256H$b_down  = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["b", 1] - summary(x)$coefficients["b", 2]))
#~ tiles256H$b2  = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["b2", 1]))
#~ tiles256H$b2_up  = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["b2", 1] + summary(x)$coefficients["b2", 2]))
#~ tiles256H$b2_down  = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["b2", 1] - summary(x)$coefficients["b2", 2]))

#~ tiles256H$a2 = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["a2", 1]))
#~ tiles256H$b2 = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["b2", 1]))
#~ tiles256H$a1 = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["a1", 1]))
#~ tiles256H$a1_up = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["a1", 1] + summary(x)$coefficients["a1", 2]))
#~ tiles256H$a1_down = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["a1", 1] - summary(x)$coefficients["a1", 2]))
#~ tiles256H$c1 = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["c1", 1]))
#~ tiles256H$c1_up = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["c1", 1] + summary(x)$coefficients["c1", 2]))
#~ tiles256H$c1_down = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["c1", 1] - summary(x)$coefficients["c1", 2]))
#~ tiles256H$s = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["s", 1]))
#~ tiles256H$s_up = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["s", 1] + summary(x)$coefficients["s", 2]))
#~ tiles256H$s_down = unlist(lapply(ww1k256H, function(x) summary(x)$coefficients["s", 1] - summary(x)$coefficients["s", 2]))

#~ write.table(as.data.frame(tiles256H[seqnames(tiles256H) == "chr4"]), "fits.256cH.chr4.tsv", sep="\t", quote=F, row.names=F)

#~ plotOnIdeo2(ideo, fName="Plots/Fits/s256cH/dinucWidth1kBins_", value_cols=c("ww", "up", "down"), val_range=c(170, 210), tiles=tiles256H)
#~ plotOnIdeo2(ideo, fName="Plots/Fits/s256cH/b1kBins_", value_cols=c("b", "b_up", "b_down"), val_range=c(0.01, 0.08), tiles=tiles256H)
#~ plotOnIdeo2(ideo, fName="Plots/Fits/s256cH/a11kBins_", value_cols=c("a1", "a1_up", "a1_down"), val_range=c(0.015, 0.16), tiles=tiles256H)
#~ plotOnIdeo2(ideo, fName="Plots/Fits/s256cH/s1kBins_", value_cols=c("s", "s_up", "s_down"), val_range=c(200, 218), tiles=tiles256H)
#~ plotOnIdeo2(ideo, fName="Plots/Fits/s256cH/c1_1kBins_", value_cols=c("c1", "c1_up", "c1_down"), val_range=c(0, 0.003), tiles=tiles256H)
#~ plotOnIdeo2(ideo, fName="Plots/Fits/s256cH/b2_1kBins_", value_cols=c("b2", "b2_up", "b2_down"), val_range=c(0, 0.006), tiles=tiles256H, col="green")
