#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=8G
#SBATCH --time=1:00:00
#SBATCH --output=output_separate.txt
#SBATCH --mail-user=aschroder@sdsu.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name="arcuata_sep"
#SBATCH -p short

#the original read files came with both left and right reads in one file
#they needed to be separated to leverage Trinity's strand-specific parameters
#Nathan Haigh's deinterleave_fastq script was used, found here https://gist.github.com/nathanhaigh/3521724

data_folder="data_arcuata"
sep="separated_data_arcuata"

./deinterleave_fastq.sh < $data_folder/Barc-C1_GTTCGGTT-AACCGAAC.fastq $data_folder/$sep/Barc-C1_r1.fastq $data_folder/$sep/Barc-C1_r2.fastq

./deinterleave_fastq.sh < $data_folder/Barc-C2_ACAGCAAC-GTTGCTGT.fastq $data_folder/$sep/Barc-C2_r1.fastq $data_folder/$sep/Barc-C2_r2.fastq

./deinterleave_fastq.sh < $data_folder/Barc-C3_CGTAGGTT-AACCTACG.fastq $data_folder/$sep/Barc-C3_r1.fastq $data_folder/$sep/Barc-C3_r2.fastq

./deinterleave_fastq.sh < $data_folder/Barc-HS1_TCATCACC-GGTGATGA.fastq $data_folder/$sep/Barc-HS1_r1.fastq $data_folder/$sep/Barc-HS1_r2.fastq

./deinterleave_fastq.sh < $data_folder/Barc-HS2_TGTGCGTT-AACGCACA.fastq $data_folder/$sep/Barc-HS2_r1.fastq $data_folder/$sep/Barc-HS2_r2.fastq

./deinterleave_fastq.sh < $data_folder/Barc-HS3_ACCATCCA-TGGATGGT.fastq $data_folder/$sep/Barc-HS3_r1.fastq $data_folder/$sep/Barc-HS3_r2.fastq

exit 0







