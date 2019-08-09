count_matrix="Trinity_cdhit_Barc.isoform.TPM.not_cross_norm"
transcriptome_file="../cdhit_0.9_Barc.fasta"
gene_trans_map="../cdhit_0.9_Barc.fasta.gene_trans_map"
RSEM_file_folder="../RSEM_output"



counts_file="Trinity_cdhit_Barc.gene.counts.matrix"
#TMM_matrix="Trinity_cdhit_Barc.gene.TMM.EXPR.matrix"
TMM_matrix="DGE_genes_Barc.TMM.EXPR.matrix"
R_outfile="Barc_gene_clustering_output"
samples_file="Barc_cdhit_samples.txt"



module load trinity-rnaseq



#$TRINITY_HOME/util/abundance_estimates_to_matrix.pl --est_method RSEM --gene_trans_map $gene_trans_map --out_prefix Trinity_cdhit_Barc $RSEM_file_folder/Barc-C1_RSEM/cdhit_Barc-C1_RSEM.isoforms.results  $RSEM_file_folder/Barc-C2_RSEM/cdhit_Barc-C2_RSEM.isoforms.results $RSEM_file_folder/Barc-C3_RSEM/cdhit_Barc-C3_RSEM.isoforms.results $RSEM_file_folder/Barc-HS1_RSEM/cdhit_Barc-HS1_RSEM.isoforms.results $RSEM_file_folder/Barc-HS2_RSEM/cdhit_Barc-HS2_RSEM.isoforms.results  $RSEM_file_folder/Barc-HS3_RSEM/cdhit_Barc-HS3_RSEM.isoforms.results

#$TRINITY_HOME/Analysis/DifferentialExpression/run_DE_analysis.pl --matrix $counts_file --method DESeq2 --samples_file $samples_file

#awk {'print $1,-$7,$11}' DESeq*/Trinity_cdhit_Barc.gene.counts.matrix.Control_vs_HS.DESeq2.DE_results > not_filtered_Barc_cdhit_DEGs.txt

#python findDGEs.py

#exit 0

#$TRINITY_HOME/util/filter_low_expr_transcripts.pl --matrix $count_matrix --transcripts $transcriptome_file --highest_iso_only --trinity_mode > Trinity_cdhit_Barc_filtered_by_expression_percentage.fasta

#grep ">" Trinity_cdhit_Barc_filtered_by_expression_percentage.fasta | awk -F">" '{print $2}' | awk -F" " '{print $1}' > Barc_cdhit_highest_exp_isoform.txt

#exit 0
#######$TRINITY_HOME/Analysis/DifferentialExpression/analyze_diff_expr.pl --matrix $expression_file --samples ../$samples_file --output $R_outfile -C 4


#$TRINITY_HOME/Analysis/DifferentialExpression/PtR -m $TMM_matrix -s $samples_file --heatmap --log2 --min_colSums 0 --min_rowSums 0 --gene_dist euclidean --sample_dist euclidean --center_rows --output $R_outfile --save


echo "done with analyze diff expr"

$TRINITY_HOME/Analysis/DifferentialExpression/define_clusters_by_cutting_tree.pl --Ptree 40 -R $R_outfile.RData

echo "done with clustering"
