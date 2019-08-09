#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=8G
#SBATCH --time=3-00:00:00
#SBATCH --output=output_1.0_trinotate.txt
#SBATCH --mail-user=aschroder@sdsu.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name="trinotate_1"
#SBATCH -p batch


# ------------- are you changing the number of cpus?  ---------------------#
# blastx -num-threads
# blastp -num-threads
# hmmscan -cpu

# this script expects that you have run the trinotate_0_setup file
# you should already have the transdecoder

#load required modules from hpcc
module load trinity-rnaseq/2.2.0
module load ncbi-blast
module load hmmer
module load trinotate
module load transdecoder
module load db-uniprot
module load db-pfam

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
UNIPROT_HOME="../../../../trinotate/trinotate_essentials/"
#PFAM_HOME="../trinotate_essentials"

#move into output directory for all intermediate files
cd output

#run blastx on uniprot database
#like blastn but on all 6 reading frames

if [ ! -f blastx_uniprot.txt ]; then
  echo "Running blastx on Uniprot..."
  blastx -query ../$fasta -db $UNIPROT_HOME/uniprot_sprot.pep -num_threads 32 -max_target_seqs 1 -outfmt 6 -out blastx_uniprot.txt
else
  echo "Blastx on Uniprot already run."
fi

#run blastp on transdecoder sequences
#derived from original fasta file

if [ ! -f blastp_uniprot.txt ]; then
  echo "Running blastp on Uniprot..."
  blastp -query $fasta.transdecoder.pep -db $UNIPROT_HOME/uniprot_sprot.pep -num_threads 32 -max_target_seqs 1 -outfmt 6 -out blastp_uniprot.txt
else
  echo "Blastp on Uniprot already run."
fi

#run HMMER against Pfam for transdecoder sequences
if [ ! -f pfam.out ]; then
  echo "Running HMMER..."
  hmmscan --domtblout pfam_out.txt --cpu 32 $PFAM_DB/Pfam-A.hmm $fasta.transdecoder.pep
else
  echo "HMMscan already run."
fi

echo "Required Trinotate analysis complete."
