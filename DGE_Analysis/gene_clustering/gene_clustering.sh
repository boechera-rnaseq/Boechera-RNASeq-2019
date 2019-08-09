#input files from previous analysis

#trinity output files
transcriptome_file="../cdhit_0.9_Barc.fasta"
gene_trans_map="../cdhit_0.9_Barc.fasta.gene_trans_map"

#path to RSEM count files
RSEM_file_folder="../RSEM_output"

#samples file correlating sample name to experimental group
samples_file="Barc_cdhit_samples.txt"

#output matrix files from abundance_estimates_to_matrix.ph
count_matrix="Trinity_cdhit_Barc.isoform.TPM.not_cross_norm"
counts_file="Trinity_cdhit_Barc.gene.counts.matrix"

#output of findDGEs.py
#matrix used to calculate dendrogram
TMM_matrix="DGE_genes_Barc.TMM.EXPR.matrix"

#designate prefix for clustering output files
R_outfile="Barc_gene_clustering_output"

#load required modules from hpcc
module load trinity-rnaseq


#combine separate RSEM files into a single matrix for downstream processing
#must input RSEM.isoform files, gene_trans_map will be used to quantify GENE-level data
$TRINITY_HOME/util/abundance_estimates_to_matrix.pl --est_method RSEM --gene_trans_map $gene_trans_map --out_prefix Trinity_cdhit_Barc $RSEM_file_folder/Barc-C1_RSEM/cdhit_Barc-C1_RSEM.isoforms.results  $RSEM_file_folder/Barc-C2_RSEM/cdhit_Barc-C2_RSEM.isoforms.results $RSEM_file_folder/Barc-C3_RSEM/cdhit_Barc-C3_RSEM.isoforms.results $RSEM_file_folder/Barc-HS1_RSEM/cdhit_Barc-HS1_RSEM.isoforms.results $RSEM_file_folder/Barc-HS2_RSEM/cdhit_Barc-HS2_RSEM.isoforms.results  $RSEM_file_folder/Barc-HS3_RSEM/cdhit_Barc-HS3_RSEM.isoforms.results

#optional way to run DESeq2
#$TRINITY_HOME/Analysis/DifferentialExpression/run_DE_analysis.pl --matrix $counts_file --method DESeq2 --samples_file $samples_file

#collect important columns in output file
#gene name, fold change, adjusted p-value
awk {'print $1,-$7,$11}' DESeq*/Trinity_cdhit_Barc.gene.counts.matrix.Control_vs_HS.DESeq2.DE_results > not_filtered_Barc_cdhit_DEGs.txt

#run python script to select which genes from DGE analysis will be used to create dendrogram
#threshold for up- and downregulation and p-value can be set here
python findDGEs.py

#exit 0

#used in annotation analysis to select for isoform with highest expression by percent
$TRINITY_HOME/util/filter_low_expr_transcripts.pl --matrix $count_matrix --transcripts $transcriptome_file --highest_iso_only --trinity_mode > Trinity_cdhit_Barc_filtered_by_expression_percentage.fasta
grep ">" Trinity_cdhit_Barc_filtered_by_expression_percentage.fasta | awk -F">" '{print $2}' | awk -F" " '{print $1}' > Barc_cdhit_highest_exp_isoform.txt


#only one of these is needed to create dendrogram and heatmap
#analyze_diff_expr.pl calls PtR internally to run the same analysis
#however, analyze_diff_expr.pl does not have the strict definitions of up- and downregulation from findDGEs.py
#PtR will use output from findDGEs.py so specific genes of interest can be clustered

#$TRINITY_HOME/Analysis/DifferentialExpression/analyze_diff_expr.pl --matrix $expression_file --samples ../$samples_file --output $R_outfile -C 4
#$TRINITY_HOME/Analysis/DifferentialExpression/PtR -m $TMM_matrix -s $samples_file --heatmap --log2 --min_colSums 0 --min_rowSums 0 --gene_dist euclidean --sample_dist euclidean --center_rows --output $R_outfile --save

echo "done with analyze diff expr"

#use results of dendrogram to create clusters
$TRINITY_HOME/Analysis/DifferentialExpression/define_clusters_by_cutting_tree.pl --Ptree 40 -R $R_outfile.RData

echo "done with clustering"
