#!/bin/bash
#SBATCH --array=0-4
#SBATCH -c 8
#SBATCH -J NucATAC
#SBATCH -p low
#SBATCH --mem 5G


### INPUT config (modify this) ###

# bam files with mapped paired-end ATAC data:
files=(ATAC256CL.trim.sorted.bam ATAC32.trim.sorted.bam ATAC128C.trim.olifant.sorted.bam ATAC256CH.trim.sorted.bam ATAC.30pEpi.sorted.bam)
# in SBATCH above make sure the array spans 0:length(files)-1

# where the files are located:
dir=/mnt/biggles/csc_home/piotr/Work/ATAC_bbsrc/Mapped/

# project name (appended to the files, can be an empty string)
project=".earlyOpen"

# regions of interest:
regionF=/mnt/biggles/csc_home/piotr/Work/ATAC_bbsrc/EarlyOpenProms/upregulated.atac.proms.bed

# chromosome sizes stored in here:
assemblyF=/mnt/biggles/csc_projects/gtan/projects/ancora/export_data/data/goldenpath/danRer7/assembly.sizes



### CODE (no need to modify) ###

echoerr() { cat <<< "$@" 1>&2; }

f=${files[$SLURM_ARRAY_TASK_ID]}

echoerr Running NucleoATAC on $dir$f
out=$(basename $f .sorted.bam)$project

source /mnt/biggley/home/piotr/Soft/nucleoatac-2015-09-01/bin/activate
nucleoatac run \
    --bed $regionF \
    --bam $dir$f \
    --fasta /mnt/biggley/data/bowtie_references/bowtie/danRer7.fa \
    --cores 8 \
    --out $out
deactivate

# convert the results to bigWig:
echoerr Converting to bigWigs:

wigToBigWig $out.occ.bedgraph.gz $assemblyF NucATAC_occ.$out.bw
wigToBigWig $out.nucleoatac_signal.bedgraph.gz $assemblyF NucATAC_sig.$out.bw
wigToBigWig $out.nucleoatac_signal.smooth.bedgraph.gz $assemblyF NucATAC_sig_smooth.$out.bw
