import csv

#input files from previous DGE analysis
R_DGE_unfiltered = "not_filtered_Barc_cdhit_DEGs.txt"
TMM_file = "Trinity_cdhit_Barc.gene.TMM.EXPR.matrix"

#designated output files
new_matrix_file = "DGE_genes_Barc.TMM.EXPR.matrix"
out_DGE_file = "Barc_cdhit_DGE.txt"
#R_DGE_outfile = "Trinity_R_DGE_cdhit_Barc.csv"

#all DGEs - adj p-value < 0.05
DGE_gene_list = list()

#DEGs that were up- or downregulated
desired_gene_list = list()


#read file in to csv reader
f = open(R_DGE_unfiltered, "r")
DGE_reader = csv.reader(f, delimiter = " ")
next(DGE_reader) #skip header

#for each line, check if gene is DGE - add to DGE_gene_list
#if DGE, check if fold change qualifies as up or downregulated - add to desired_gene_list
for line in DGE_reader:
  geneName = line[0]
  logFold = float(line[1])
  FDR = float(line[2])
  if (FDR < 0.05):
    DGE_gene_list.append(line)
    if (logFold > 4 and FDR < 0.001):
      desired_gene_list.append(geneName)
    elif (logFold < -4 and FDR < 0.001):
      desired_gene_list.append(geneName)

#close csv reader
f.close()

#correlate gene name with count matrix
#resulting matrix file will only contain genes of interest for dendrogram and clutering

#open original count matrix
i_f = open(TMM_file, "r")
TMM_reader = csv.reader(i_f, delimiter="\t")
header = next(TMM_reader) #store header

#open output file
o_f = open(new_matrix_file, "w")
matrix_writer = csv.writer(o_f, delimiter = "\t")
matrix_writer.writerow(header)

#go through original count matrix line by line
#if line correlates to a gene in the desired gene list, write to output file
#else go to next line
for line in TMM_reader:
  if line[0] in desired_gene_list:
    matrix_writer.writerow(line)
    
#close both files
i_f.close()
o_f.close()

#write all DGE genes to file
f = open(out_DGE_file, "w")
DGE_writer = csv.writer(f, delimiter = "\t")
DGE_writer.writerow("Name, log2FoldChange, padj")
DGE_writer.writerows(DGE_gene_list)
f.close()
