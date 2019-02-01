#!/bin/bash
#SBATCH -c 16
#SBATCH -J ritornello
#SBATCH --mem 20G
#SBATCH --array 1-4

# in 10/11 cases 10GB was enough

f=`head -n $SLURM_ARRAY_TASK_ID filelist.txt | tail -1`

echo Running Ritornello on $f
d=`basename $f .bam`
mkdir -p $d
cd $d

/usr/local/bin/Ritornello -f ../$f -p 16 &
cpulimit -c 16 -l 1600 -p $!
wait
cd ..

#tail -n +2 $f LC_ALL=C sort -k1,1 -k2,2n
