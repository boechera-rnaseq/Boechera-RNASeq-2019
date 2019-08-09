#set working directory
#setwd("C:\\Users\\Allison\\Desktop\\DESeq Genes\\rsem_results")
setwd("C:\\Users\\Allison\\Desktop\\cdhit_RSEM\\RSEM")
#source("https://bioconductor.org/biocLite.R")
#biocLite("ComplexHeatmap")
#biocLite("DESeq2")
#biocLite("tximport")

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("tximport")
BiocManager::install("DESeq2")


#library(ComplexHeatmap)
library(tximport)
library(DESeq2)
#library(pheatmap)

#import rsem files and name groups
files=list.files(getwd())

sampleNames = sub("[.].*", "", files); sampleNames = sub(".*/", "", sampleNames)
names(files) = sampleNames

#create txi object
txi.rsem=tximport(files, type="rsem", txIn=FALSE, txOut = FALSE)
head(txi.rsem$counts)

#create DESeq object
sampleTable = data.frame(condition=factor(rep(c("C", "HS"),each=3)))
rownames(sampleTable) = colnames(txi.rsem$counts)
ddsTXI = DESeqDataSetFromTximport(txi.rsem, sampleTable, ~condition)

dds=DESeq(ddsTXI)

#get DESeq2 results
res=results(dds)
#write.csv(res,"../results_unfiltered.csv")
#res=res[!(res$baseMean<5),]
res=res[c(which(res$padj<0.05)),]
res=res[order(-res$log2FoldChange),]
#write.csv(res,"../R_results_cdhit_Bper_R_DGE_6_26_base_mean.csv")
#filter out the columns with gene name, log fold change, and padj
results_foldchange=res[c("log2FoldChange","padj")]

#write to files
write.csv(results_foldchange,"../cdhit_Bper_R_DGE_6_26_base_mean.csv")
write.csv(head(results_foldchange,50),"../top_50_upregulated.csv")
write.csv(results_foldchange[c(which(results_foldchange$log2FoldChange>2)),],"../DEG_over_2_LFC.csv")
write.csv(results_foldchange[c(which(results_foldchange$log2FoldChange<-2)),],"../DEG_over_neg2_LFC.csv")


#results_foldchange[results_foldchange$log2FoldChange >=4]
#MA plot of differentially expessed genes
plotMA(dds, ylim=c(-20, 20))

#heatmap of most upregulated genes
rltransform = rlog(dds, blind=F)
highestVarGenes = order(rowVars(assay(rltransform)), decreasing = T)
highestVarGenes = head(highestVarGenes, 20)
matrix = assay(rltransform[highestVarGenes])
Heatmap(matrix)

vsd = vst(dds)
select = which(res$padj<0.05)[1:20]
select = order(rowMeans(counts(dds,TRUE)),decreasing=TRUE)
pheatmap(assay(vsd)[select,])
