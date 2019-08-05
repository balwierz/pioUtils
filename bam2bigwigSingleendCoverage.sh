#!/bin/bash
#SBATCH -c 4
#SBATCH -J bam_se-->bw
#SBATCH --mem-per-cpu 6G
#SBATCH -t 1-0

if [[ -z $SLURM_CPUS_PER_TASK ]]
then
	SLURM_CPUS_PER_TASK=4	# if run outside of SLURM
fi

opts=""

while [[ -n $1 ]]; do
  case $1 in
    --strand)
      fStrand=1
      ;;
    --extval)
      shift
      opts="$opts --extval $1"
      ;;
    --out)
	  shift
      outFile=$1
      ;;
    *)
      inFile=$1
      ;;
  esac
  shift
done

if [[ -z $outFile ]]
then
	outFile=$(basename $inFile .bam)
fi

if [[ -n $fStrand ]]
then
	bam2wig.pl $opts --pos span --strand --nope --nomodel --rpm --in $inFile --cpu $SLURM_CPUS_PER_TASK --nogz --out $outFile.coverage.wig
	# negate negative strand values:
	perl -wane '$F[3] = -$F[3]; print join("\t", @F), "\n"' $outFile.coverage_r.bdg > $outFile.coverage_r.bdg.new
	mv $outFile.coverage_r.bdg.new $outFile.coverage_r.bdg
	# convert to bedgraph:
	bedGraphToBigWig -clip $outFile.coverage_f.bdg /mnt/biggles/data/UCSC/goldenpath/danRer7/chromInfo.txt $outFile.coverage_f.bw
	bedGraphToBigWig -clip $outFile.coverage_r.bdg /mnt/biggles/data/UCSC/goldenpath/danRer7/chromInfo.txt $outFile.coverage_r.bw
	#rm $outFile.coverage_f.bdg $outFile.coverage_r.bdg
else
	bam2wig.pl $opts --pos span --nope --nomodel --rpm --in $inFile --cpu $SLURM_CPUS_PER_TASK --nogz --bw --out $outFile.coverage.wig
fi
