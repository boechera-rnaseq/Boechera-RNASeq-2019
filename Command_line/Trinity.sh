#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=10G
#SBATCH --time=7-00:00:00
#SBATCH --output=output_trinity_arcuata.txt
#SBATCH --mail-user=aschroder@sdsu.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name="trinity_arcuata"
#SBATCH -p batch

#load modules from hpcc
module load trinity-rnaseq/2.6.6
module load bowtie2

######################################################################################################3
#  if you are getting numpy errors you need to fix it *at command line* not in script:
#  on command line:  conda activate hpcc-base
#  you should see (hpcc-base) in front of command line prompt
#  then go ahead and rerun script on batch
#######################################################################################################

table_o_files="table_arcuata.txt"
cpu="32"
max_mem="280G"

#necessary for --quality_trimming_params
#in this case, used to ask trimmomatic to retain both reads of a pair, even if one is "contained" in the other
TRIMMOMATIC_DIR="/bigdata/operations/pkgadmin/opt/linux/centos/7.x/x86_64/pkgs/trinity-rnaseq/2.6.6/trinity-plugins/Trimmomatic"

$TRINITY_HOME/Trinity --trimmomatic --quality_trimming_params "ILLUMINACLIP:$TRIMMOMATIC_DIR/adapters/TruSeq3-PE.fa:2:30:10:4:TRUE SLIDINGWINDOW:4:5 LEADING:5 TRAILING:5 MINLEN:50" --seqType fq --SS_lib_type RF --samples_file $table_o_files --CPU $cpu --max_memory $max_mem --bflyCalculateCPU;
 
exit 0


