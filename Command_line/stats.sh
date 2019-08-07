#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks=10
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=12G
#SBATCH --time=1-00:00:00
#SBATCH --output=output_stats.txt
#SBATCH --mail-user=aschroder@sdsu.edu
#SBATCH --mail-type=ALL
#SBATCH --job-name="stats_Barc"
#SBATCH -p batch

#load modules from hpcc
module load trinity-rnaseq
module load bowtie2

#create separate directory for output files
mkdir stats

group="Barc"
align_file="../stats/bowtie2_Barc_align.txt"

#stats for trinity assembly
$TRINITY_HOME/util/TrinityStats.pl trinity_out_dir/Trinity.fasta > stats/trinity_stats_$group.txt;

#get read alignment stats
#there are a lot of intermediate files, keep them in trinity out dir

echo "starting bowtie2 analysis..."
    
cd trinity_out_dir

#index transcriptome for faster alignment
bowtie2-build Trinity.fasta Trinity_fasta

#running this will give total alignment rate for all reads
#bowtie2 -x Trinity_fasta -1 Barc-C1_r1.fastq.gz.PwU.qtrim.fq,Barc-C2_r1.fastq.gz.PwU.qtrim.fq,Barc-C3_r1.fastq.gz.PwU.qtrim.fq,Barc-HS1_r1.fastq.gz.PwU.qtrim.fq,Barc-HS2_r1.fastq.gz.PwU.qtrim.fq,Barc-HS3_r1.fastq.gz.PwU.qtrim.fq -2 Barc-C1_r2.fastq.gz.PwU.qtrim.fq,Barc-C2_r2.fastq.gz.PwU.qtrim.fq,Barc-C3_r2.fastq.gz.PwU.qtrim.fq,Barc-HS1_r2.fastq.gz.PwU.qtrim.fq,Barc-HS2_r2.fastq.gz.PwU.qtrim.fq,Barc-HS3_r2.fastq.gz.PwU.qtrim.fq -q -k 20 --no-unal -p 10 2>$align_file | samtools view -@10 -Sb -o bowtie2.bam

#exit 0

#running this will give alignment for each set of reads
group="Barc-C1"
align_file="../stats/bowtie2_"$group"_stats.txt"

bowtie2 -x Trinity_fasta -1 "$group"_r1.fastq.gz.PwU.qtrim.fq -2 "$group"_r2.fastq.gz.PwU.qtrim.fq -q -k 20 --no-unal -p 10 2>$align_file | samtools view -@10 -Sb -o bowtie2.bam

group="Barc-C2"
align_file="../stats/bowtie2_"$group"_stats.txt"

bowtie2 -x Trinity_fasta -1 "$group"_r1.fastq.gz.PwU.qtrim.fq -2 "$group"_r2.fastq.gz.PwU.qtrim.fq -q -k 20 --no-unal -p 10 2>$align_file | samtools view -@10 -Sb -o bowtie2.bam

group="Barc-C3"
align_file="../stats/bowtie2_"$group"_stats.txt"

bowtie2 -x Trinity_fasta -1 "$group"_r1.fastq.gz.PwU.qtrim.fq -2 "$group"_r2.fastq.gz.PwU.qtrim.fq -q -k 20 --no-unal -p 10 2>$align_file | samtools view -@10 -Sb -o bowtie2.bam

group="Barc-HS1"
align_file="../stats/bowtie2_"$group"_stats.txt"

bowtie2 -x Trinity_fasta -1 "$group"_r1.fastq.gz.PwU.qtrim.fq -2 "$group"_r2.fastq.gz.PwU.qtrim.fq -q -k 20 --no-unal -p 10 2>$align_file | samtools view -@10 -Sb -o bowtie2.bam

group="Barc-HS2"
align_file="../stats/bowtie2_"$group"_stats.txt"

bowtie2 -x Trinity_fasta -1 "$group"_r1.fastq.gz.PwU.qtrim.fq -2 "$group"_r2.fastq.gz.PwU.qtrim.fq -q -k 20 --no-unal -p 10 2>$align_file | samtools view -@10 -Sb -o bowtie2.bam

group="Barc-HS3"
align_file="../stats/bowtie2_"$group"_stats.txt"

bowtie2 -x Trinity_fasta -1 "$group"_r1.fastq.gz.PwU.qtrim.fq -2 "$group"_r2.fastq.gz.PwU.qtrim.fq -q -k 20 --no-unal -p 10 2>$align_file | samtools view -@10 -Sb -o bowtie2.bam

cat 2>&1 $align_file

echo "finished with stats analysis"

echo "**************************bowtie 2 sam file created**************************************" >> $align_file

samtools view -bS samalign.sam -o samalign.bam 2>> $align_file

echo "done with bowtie2 analysis"
