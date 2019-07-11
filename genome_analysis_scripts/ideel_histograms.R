#!/usr/bin/env Rscript
library(ggplot2)
library(stringr)

# Load in data ---------------------------------------------------------------
raw_roth <- read.table("ideel/raw_rothamsted_Assembly.data",
                       sep="\t", header=FALSE)
clean_roth <- read.table("ideel/cleaned_rothamsted_Assembly.data",
                         sep="\t", header=FALSE)
comb500 <- read.table("ideel/smrtcell_combined_cov500.data",
                      sep="\t", header=FALSE)
hybrid <- read.table("ideel/clean_rothamsted_reads_smrtcell1_hybrid_Assembly.data",
                     sep = "\t", header = FALSE)
comb200 <- read.table("ideel/smrtcombined.cov200.faa.data",
                      sep="\t", header=FALSE)
smrt1_cov200 <- read.table("ideel/smrtcell1.cov200.faa.data",
                           sep="\t", header=FALSE)
smrt2_cov200 <- read.table("ideel/smrtcell2.cov200.faa.data",
                           sep="\t", header=FALSE)
ccs <- read.table("ideel/ccs.faa.data",
                  sep="\t", header=FALSE)
ccs.pacasus <- read.table("ideel/pacasus.ccs.arrow.faa.data",
                          sep="\t", header=FALSE)
pacasus_cov200 <- read.table("ideel/pacasus.smrtcell2_200xcov.faa.data",
                           sep="\t", header=FALSE)

# Prepare data ---------------------------------------------------------------
# Add an assembly name column to each 
raw_roth$Assembly <- "illumina_raw"
clean_roth$Assembly <- "illumina_clean"
comb200$Assembly <- "comb200"
comb500$Assembly <- "comb500"
hybrid$Assembly <- "hybrid"
ccs$Assembly <- "ccs"
ccs.pacasus$Assembly <- "pacasus.ccs"
smrt2_cov200$Assembly <- "SMRTcell 2"
smrt1_cov200$Assembly <- "SMRTcell 1"
pacasus_cov200$Assembly <- "SMRTcell2 pacasus"

# Combine a subset of datasets into a single table 
pacasus <- rbind(smrt2_cov200,
                 smrt1_cov200,
                 pacasus_cov200)

# add a column to store the ratio of query length to uniprot hit
pacasus$pc <- pacasus$V1/pacasus$V2
pacasus$Assembly <- as.factor(pacasus$Assembly)
# change the order of assembly factors for plotting
print(levels(pacasus$Assembly))
pacasus$Assembly <- factor(pacasus$Assembly,
                           levels(pacasus$Assembly)[c(2, 1, 3)])

# Plot histogram -------------------------------------------------------------
ggplot(pacasus, aes(x=pc,group=Assembly,fill=Assembly)) + 
  geom_histogram(position="identity",
                 alpha = 0.7,
                 binwidth=0.05) + 
  xlim(0,2) + xlab("Ratio of predicted gene length to UniProt hit") + 
  ylab("Frequency") + 
  scale_fill_manual(values=c("#91bfdb", "#fc8d59", "#ffffbf"))

#scale_fill_manual(values = c("#66c2a5", "#fc8d62", "#8da0cb"))
ggsave("smrtcell_pacasus_uniprot_hit_comparison.svg", dpi = 1200)

# Count the number of Query proteins less than 90% of the best UniProt hit
less90 <- pacasus[best$pc < 0.9, ]
sum(str_count(less90$Assembly, "SMRTcell 1"))
sum(str_count(less90$Assembly, "SMRTcell2 pacasus"))
sum(str_count(less90$Assembly, "SMRTcell 2"))

