bpapply = function(X, MARGIN, FUN, ...)
{
	# By Piotr
	require(BiocParallel)
	if(MARGIN==1) #rowwise
	{
		if(!is.null(rownames(X)))
			f = factor(rownames(X))
		else
			f = factor(seq_along(dim(X, 1)))
		ret = bplapply(X=split(X, f=f), FUN=FUN, ...)
		return(ret)
	}
	else if(MARGIN==2)  #columnwise
	{
		ret = bplapply(X=as.list(X), FUN=FUN, ...)
		return(ret)
	}
	else
	{
		stop("MARGIN needs to be \\in {1,2} in bpapply\n")
	}
}
