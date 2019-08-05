#!/bin/bash
#SBATCH -c 8
#SBATCH -J extATAC
#SBATCH --mem 8G

# usage: $1 - bam file of ATAC seq; [extsize=50] [assembly=danRer7]
# extsize needs to be even
## warning: do not use, as of Bio::ToolBox 1.54
## submitted bug report:
## https://github.com/tjparnell/biotoolbox/issues/10

if [[ -z $1 ]]
then
        echo "Usage: sbatch thisFILE atac.bam <extSize=50> <assembly=danRer7>"
        exit 1
fi

extSize=$2
if [[ -z $extSize ]]
then
	extSize=50
fi

assembly=$3
if [[ -z $assembly ]]
then
	assembly=danRer7
fi

assemblySizes="/mnt/biggles/data/UCSC/goldenpath/$assembly/chromInfo.txt"

set -e

# prepare output filename:
bb=`basename $1 .bam`
bb=`basename $bb .goodChr`
bb=`basename $bb .sorted`
bb=`basename $bb .goodChr`

echoerr() { cat <<< "$@" 1>&2; }


thisTemp=$(mktemp --directory /mnt/scratch/$(whoami)/bam2wig_XXXXXX)
# actually bam2wig.pl creates its own temp dir there but does not report its name, so we create a temp to know the name
echoerr binning ATAC $1 in $thisTemp on $(hostname)
bam2wig.pl --temp $thisTemp --extend --rpm --nope --shift --shiftval $((-$extSize/2 + 4)) --extval $extSize --var --in $1 --cpu 8 --nogz --bw --out $bb.cuts.ext$extSize.bw
rmdir $thisTemp

# piotr old patched: /mnt/biggles/opt/BioToolBox/biotoolbox-master/scripts/bam2wig.pl
