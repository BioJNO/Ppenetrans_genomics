# Load required packages -----------------------------------------------------
library(UpSetR)
library(ggplot2)
library(reshape2)
library(plyr)
library(svglite)

# Load in data ---------------------------------------------------------------
clustersummary <- read.csv("TAXON.cluster_summary.csv")
annotation <- read.csv("cluster_functional_annotation.all.p75.x75.csv")

# Merge summary and annotation data.
merged <- merge(clustersummary, annotation, by = "X.cluster_id")
# Subset required columns for intersect plotting.
merged_sub <- merged[,c(1,9:14)]
rownames(merged_sub) <- merged_sub[,1]
merged_sub <- merged_sub[,-1]

# Data analysis --------------------------------------------------------------
# Subset shared, specific and singleton clusters.
shared <- clustersummary[grep("shared", clustersummary$attribute_cluster_type),]
specific <- clustersummary[grep("specific", clustersummary$attribute_cluster_type),]
singleton <- clustersummary[grep("singleton", clustersummary$attribute_cluster_type),]

# Get the total number of proteins in each subgroup.
allsums <- colSums(tab[,9:14])
allsums
shared <- colSums(shared[,9:14])
shared
specific <- colSums(specific[,9:14])
specific
singleton <- colSums(singleton[,9:14])
singleton

# Store sums as a simple data frame.
clustersum <- data.frame(shared, specific, singleton)
# Transpose this data frame.
clustersum <- t(clustersum)
# Convert to long format.
clustersum_melt <- melt(clustersum, id.vars = rownames(tx))
clustersum_melt <- rename(clustersum_melt, c("Var1"="cluster_type", "Var2"="proteome"))

# Get sums as a proportion of the total
clusterprop <- scale(clustersum, center = F, scale = colSums(clustersum))
clusterprop_melt <- melt(clusterprop, id.vars = rownames(clusterprop))
clusterprop_melt <- rename(clusterprop_melt, c("Var1"="cluster_type", "Var2"="proteome"))

# Prepare data for intersect plotting.
# Convert counts to binary presence/abscence.
merged_sub$B.cereus <- ifelse(merged_sub$BCER_count>0, 1, 0)
merged_sub$C.difficile <- ifelse(merged_sub$CDIF_count>0, 1, 0)
merged_sub$P.penetrans <- ifelse(merged_sub$PPEN_count>0, 1, 0)
merged_sub$B.subtilis <- ifelse(merged_sub$BSUB_count>0, 1, 0)
merged_sub$T.vulgaris <- ifelse(merged_sub$TVUL_count>0, 1, 0)
merged_sub$B.thuringiensis <- ifelse(merged_sub$BTHU_count>0, 1, 0)
# Remove counts
merged_sub <- merged_sub[,-c(1:6)]

# Shared/Specific/Singleton plots --------------------------------------------
# Create a color blind friendly pallette.
cbPalette <- c("#E69F00",
               "#56B4E9",
               "#009E73",
               "#F0E442",
               "#0072B2",
               "#D55E00",
               "#CC79A7")

# Plot subgroups in terms of total proteins.
totalplot <- ggplot(dat.m,
                    aes(x = proteome,
                        y = value,
                        fill = cluster_type)) + 
             geom_bar(stat="identity") + 
             coord_flip() + 
             scale_fill_manual(values = cbPalette)
totalplot

ggsave("totalplot.svg",
       dpi = 600,)

# Plot subgroups as a proportion of total.
# Create a list of proteome organisms for neat naming.
Proteomes <- c("Thermoactinomyces vulgaris",
               "Pasteuria penetrans",
               "Clostridioides difficile",
               "Bacillus thuringiensis",
               "Bacillus subtilis",
               "Bacillus cereus")

# Bar graph of proportional subgroup data.
proportionplot <- ggplot(dat.m,
                  aes(x = proteome,
                      y = value,
                      fill = cluster_type)) + 
                  geom_bar(stat="identity") + 
                  coord_flip() + 
                  scale_fill_manual(values = cbPalette) + 
                  labs(x="Proteome", y="Proportion of total proteome",
                  fill="Cluster Type") + 
                  theme(axis.text.y = element_text(face="italic", size = 10)) +
                        scale_x_discrete(labels=rev(Proteomes))
proportionplot

ggsave("proportionplot.svg",
        dpi = 600)

# Intersect plot -------------------------------------------------------------
# Create a list of set names from column headers.
setnames <- colnames(merged_sub)
setnames

upset(merged_sub, sets = setnames, order.by = "freq")

ggsave("UpSetTotalProteomePlot.svg",
        dpi = 600)
