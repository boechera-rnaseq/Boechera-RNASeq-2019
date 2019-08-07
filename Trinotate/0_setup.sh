#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=8G
#SBATCH --time=30:00
#SBATCH --output=output_0.txt
#SBATCH --mail-user=aschroder@sdsu.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name="trinotate_setup_0"
#SBATCH -p short


#this is the setup file before any trinotate analysis is run

#load modules from hpcc

module load trinity-rnaseq
module load trinotate
module load transdecoder

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

#path to directory wherever your running the script
TRANSDECODER_HOME="/opt/linux/centos/7.x/x86_64/pkgs/transdecoder/5.0.2"
TRINOTATE_HOME="/opt/linux/centos/7.x/x86_64/pkgs/trinotate/3.0.1"

if [ ! -d output ]; then
    mkdir output
fi

#check for output file from TransDecoder, skip if present

if [ ! -f output/$fasta.transdecoder.pep ]; then

    $TRANSDECODER_HOME/TransDecoder.LongOrfs -t $fasta

    $TRANSDECODER_HOME/TransDecoder.Predict -t $fasta
else
    echo "TransDecoder already run."
fi

#move transdecoder output to output folder


mv $fasta.transdecoder* output
mv pipeliner* output

echo "Setup complete."
