library(purrr)
library(rtracklayer)
list.files("/mnt/orca/damir/OneDrive/DANIO-CODE/methylation/danRer10/dancode_danRer10",
		   pattern="danRer10.+\\.bigwig", full.names=T) %>% `names<-`(.,.) %>%
 	imap(function(f, n)
 	{
 		r <- import.bw(f)
 		r$score = r$score * 2 - 1
 		outF <- basename(n)
 		export.bw(r, outF)
 	})
