#!/usr/bin/Rscript

suppressMessages(library(rtracklayer))
suppressMessages(library(purrr))
files = list.files(path='.', pattern="\\.bw")
names(files) = files
dir.create("Results");

files %>% map(import) %>%
    imap(function(f, nnn)
    {
		paste(nnn)
		seqlevels(f)[seqlevels(f) == "MT"] = "M"
		seqlevels(f) = paste0("chr", seqlevels(f))
		export.bw(f, paste0("Results/", nnn), compress=TRUE)
	})
