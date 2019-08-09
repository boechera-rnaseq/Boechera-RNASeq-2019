#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=8G
#SBATCH --time=40:00
#SBATCH --output=output_load_db.txt
#SBATCH --mail-user=aschroder@sdsu.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name="trinotate_2_load-db"
#SBATCH -p short


# ------------- are you changing the number of cpus?  ---------------------#


# this script expects that you have run the trinotate_0_setup file and the trinotate_1_required file
# trinotate_1.5_optional file is...optional

# unlike previous scripts, this requires both the trinity fasta and the trinity gene_trans_map file to initialize the database

#load required modules from hpcc
module load trinity-rnaseq
module load trinotate

sqlite="Trinotate_arcuata.sqlite"
TRINOTATE_HOME="/opt/linux/centos/7.x/x86_64/pkgs/trinotate/3.0.1"


#takes trinity fasta file and gene-to-transcript files as input

if [ $# -ne 2 ]; then
    echo "Expect Trinity fasta filename AND Trinity gene-to-transcript map file."
    exit 1
fi

fasta=$1
gene_trans_map=$2

#check if command line input is valid
if [ ! -f $fasta ]; then
    echo "Fasta not found."
    exit 1
fi

if [ ! -f $gene_trans_map ]; then
    echo "Gene-to-transcript map file not found."
    exit 1
fi

# make sure you've run all the previous files!

if [ ! -f output/$fasta.transdecoder.pep ]; then
    echo "Transdecoder output not found.  Did you run the trinotate setup file?"
    exit 1
fi

if [ ! -f $sqlite ]; then
    echo "Sqlite database not found.  Did you run the trinotate setup file?"
    exit 1
fi

if [ ! -f output/blastx_uniprot.txt ]; then
    echo "Blastx output not found.  Did you run the trinotate required analysis file?"
    exit 1
fi

if [ ! -f output/blastp_uniprot.txt ]; then
    echo "Blastp output not found.  Did you run the trinotate required analysis file?"
    exit 1
fi

if [ ! -f output/pfam_out.txt ]; then
    echo "PFAM output not found.  Did you run the trinotate required analysis file?"
    exit 1
fi



#### load results into trinotate database

#initialize database
$TRINOTATE_HOME/Trinotate $sqlite init --gene_trans_map $gene_trans_map --transcript_fasta $fasta --transdecoder_pep output/$fasta.transdecoder.pep

#load results of required annotation
$TRINOTATE_HOME/Trinotate $sqlite LOAD_swissprot_blastx output/blastx_uniprot.txt

$TRINOTATE_HOME/Trinotate $sqlite LOAD_swissprot_blastp output/blastp_uniprot.txt

$TRINOTATE_HOME/Trinotate $sqlite LOAD_pfam output/pfam_out.txt

# check for output files of optional analysis
# load into database if present

# uniref 90
#if [ -f blastx_uniref90.txt ]; then 
#  $TRINOTATE_HOME/Trinotate $sqlite LOAD_trembl_blastx output/blastx_uniref90.txt
#fi 

#if [ -f blastp_uniref90.txt ]; then 
#  $TRINOTATE_HOME/Trinotate $sqlite LOAD_trembl_blastp output/blastp_uniref90.txt
#fi

#signal p
if [ -f signalp_out.txt ]; then 
  $TRINOTATE_HOME/Trinotate $sqlite LOAD_signalp output/signalp_out.txt
fi

#tmhmm
if [ -f tmhmm_out.txt ]; then 
  $TRINOTATE_HOME/Trinotate $sqlite LOAD_tmhmm output/tmhmm_out.txt
fi

#rnammer
if [ -f $fasta.rnammer.gff ]; then 
  $TRINOTATE_HOME/Trinotate $sqlite LOAD_rnammer output/$fasta.rnammer.gff
fi

echo "Database loading complete!"

#output report to excel file
#--incl_trans will include contig sequences from trinity output
$TRINOTATE_HOME/Trinotate $sqlite report --incl_trans -E 0.00001 > trinotate_report_B_arc_6_27.txt

