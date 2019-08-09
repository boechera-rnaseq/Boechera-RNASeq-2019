#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=8G
#SBATCH --time=1:00:00
#SBATCH --output=output_1.5_optional.txt
#SBATCH --mail-user=aschroder@sdsu.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name="trinotate_1.5_optional"
#SBATCH -p short


# ------------- are you changing the number of cpus?  ---------------------#
# blastx -num-threads
# blastp -num-threads


# this script expects that you have run the trinotate_0_setup file
# these are optional additional processing steps through trinotate
# not required in sqlite database, but can be used if results are present

#load required modules from hpcc
module load trinity-rnaseq
module load ncbi-blast
module load trinotate
module load tmhmm
module load signalp
module load rnammer

#takes trinity fasta file as single cmd line input

if [ $# -ne 1 ]; then
    echo "Expect Trinity fasta filename as single command line argument."
    exit 1
fi

fasta=$1

#check if command line input is valid
if [ ! -f $fasta ]; then
    echo "Fasta not found."
    exit 1
fi

#make sure transdecoder output is present
if [ ! -f output/$fasta.transdecoder.pep ]; then
    echo "Transdecoder output not found.  Did you run the trinotate setup file?"
    exit 1
fi

TRINOTATE_HOME="/opt/linux/centos/7.x/x86_64/pkgs/trinotate/3.0.1"
#RNAMMER_HOME="/opt/linux/centos/7.x/x86_64/pkgs/rnammer/1.2/rnammer"

#move into output directory for all intermediate files
cd output

#run blastx on uniref database

#if [ ! -f blastx_uniref90.txt ]; then
#echo "Running blastx on Uniref90 ..."
#blastx -query ../$fasta -db $UNIPROT_DB/uniref90.fasta -num_threads 24 -max_target_seqs 1 -outfmt 6 -out blastx_uniref90.txt
#else
#  echo "Blastx on Uniref90 already run."
#fi

#run blastp on transdecoder sequences 
#using uniref database

#if [ ! -f blastp_uniref90.txt ]; then
#  echo "Running blastp on Uniref90..."
#  blastp -query $fasta.transdecoder.pep -db $UNIPROT_DB/uniref90.fasta -num_threads 24 -max_target_seqs 1 -outfmt 6 -out blastp_uniref90.txt
#else
#  echo "Blastp on Uniref90 already run."
#fi


#signal p predicts signal peptides
if [ ! -f signalp_out.txt ]; then
  echo "Running signalp..."
  signalp -f short -n signalp_out.txt $fasta.transdecoder.pep
else
  echo "Signalp already run."
fi


#rnammer predicts ribosomal rna
#if [ ! -f $fasta.rnammer.gff ]; then
#  echo "Running RNAmmer"
#  $TRINOTATE_HOME/util/rnammer_support/RnammerTranscriptome.pl --transcriptome ../$fasta --path_to_rnammer $RNAMMER_HOME
#else
#  echo "RNAmmer already run."
#fi

#tmhmm predicts transmembrane regions
if [ ! -f tmhmm_out.txt ]; then
#module load legacy
  echo "Running tmHMM..."
  tmhmm --short < $fasta.transdecoder.pep  > tmhmm_out.txt
else
  echo "tmHMM already run."
fi

echo "Optional Trinotate analysis complete."
