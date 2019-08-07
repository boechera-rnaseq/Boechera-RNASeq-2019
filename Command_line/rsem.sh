#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=10G
#SBATCH --time=5-00:00:00
#SBATCH --output=output_rsem.txt
#SBATCH --mail-user=aschroder@sdsu.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name="just_rsem"
#SBATCH -p batch

module load trinity-rnaseq
module load rsem
module load bowtie2

files="trinity_out_dir"
group="Bper-C1"

$TRINITY_HOME/util/align_and_estimate_abundance.pl --seqType fq --right $files/$group'_r1.fastq.gz.PwU.qtrim.fq.gz' --left $files/$group'_r2.fastq.gz.PwU.qtrim.fq.gz' --transcripts $files/Trinity.fasta --est_method RSEM --aln_method bowtie2 --trinity_mode --prep_reference --output_dir RSEM_output/$group'_RSEM'

group="Bper-C2"

$TRINITY_HOME/util/align_and_estimate_abundance.pl --seqType fq --right $files/$group'_r1.fastq.gz.PwU.qtrim.fq.gz' --left $files/$group'_r2.fastq.gz.PwU.qtrim.fq.gz' --transcripts $files/Trinity.fasta --est_method RSEM --aln_method bowtie2 --trinity_mode --prep_reference --output_dir RSEM_output/$group'_RSEM'

group="Bper-C3"

$TRINITY_HOME/util/align_and_estimate_abundance.pl --seqType fq --right $files/$group'_r1.fastq.gz.PwU.qtrim.fq.gz' --left $files/$group'_r2.fastq.gz.PwU.qtrim.fq.gz' --transcripts $files/Trinity.fasta --est_method RSEM --aln_method bowtie2 --trinity_mode --prep_reference --output_dir RSEM_output/$group'_RSEM'

group="Bper-HS1"

$TRINITY_HOME/util/align_and_estimate_abundance.pl --seqType fq --right $files/$group'_r1.fastq.gz.PwU.qtrim.fq.gz' --left $files/$group'_r2.fastq.gz.PwU.qtrim.fq.gz' --transcripts $files/Trinity.fasta --est_method RSEM --aln_method bowtie2 --trinity_mode --prep_reference --output_dir RSEM_output/$group'_RSEM'

group="Bper-HS2"

$TRINITY_HOME/util/align_and_estimate_abundance.pl --seqType fq --right $files/$group'_r1.fastq.gz.PwU.qtrim.fq.gz' --left $files/$group'_r2.fastq.gz.PwU.qtrim.fq.gz' --transcripts $files/Trinity.fasta --est_method RSEM --aln_method bowtie2 --trinity_mode --prep_reference --output_dir RSEM_output/$group'_RSEM'

group="Bper-HS3"

$TRINITY_HOME/util/align_and_estimate_abundance.pl --seqType fq --right $files/$group'_r1.fastq.gz.PwU.qtrim.fq.gz' --left $files/$group'_r2.fastq.gz.PwU.qtrim.fq.gz' --transcripts $files/Trinity.fasta --est_method RSEM --aln_method bowtie2 --trinity_mode --prep_reference --output_dir RSEM_output/$group'_RSEM'
