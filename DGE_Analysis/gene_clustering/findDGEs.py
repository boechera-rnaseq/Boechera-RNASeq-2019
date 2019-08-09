import csv

R_DGE_unfiltered = "not_filtered_Barc_cdhit_DEGs.txt"
#R_DGE_outfile = "Trinity_R_DGE_cdhit_Barc.csv"
TMM_file = "Trinity_cdhit_Barc.gene.TMM.EXPR.matrix"
desired_gene_list = list()
DGE_gene_list = list()
new_matrix_file = "DGE_genes_Barc.TMM.EXPR.matrix"
out_DGE_file = "Barc_cdhit_DGE.txt"

countUP = 0
countDown = 0
f = open(R_DGE_unfiltered, "r")
DGE_reader = csv.reader(f, delimiter = " ")
next(DGE_reader)
for line in DGE_reader:
  print(line)
  geneName = line[0]
  logFold = float(line[1])
  FDR = float(line[2])
  if (FDR < 0.05):
    DGE_gene_list.append(line)
    if (logFold > 4 and FDR < 0.001):
      countUP += 1
      desired_gene_list.append(geneName)
    elif (logFold < -4 and FDR < 0.001):
      countDown += 1
      desired_gene_list.append(geneName)
f.close()

print(countUP)
print(countDown)
print(len(desired_gene_list))

i_f = open(TMM_file, "r")
TMM_reader = csv.reader(i_f, delimiter="\t")
header = next(TMM_reader)

o_f = open(new_matrix_file, "w")
matrix_writer = csv.writer(o_f, delimiter = "\t")
matrix_writer.writerow(header)

added_genes = list()

for line in TMM_reader:
  if line[0] in desired_gene_list:
    matrix_writer.writerow(line)
    added_genes.append(line[0])
i_f.close()
o_f.close()

missing = list(set(desired_gene_list) - set(added_genes))
print(missing)


f = open(out_DGE_file, "w")
DGE_writer = csv.writer(f, delimiter = "\t")
DGE_writer.writerow("Name, log2FoldChange, padj")
DGE_writer.writerows(DGE_gene_list)

f.close()
