# Load required packages -----------------------------------------------------
library(tidyr)
library(ggfortify)
library(dplyr)
library(UpSetR)
library(factoextra)

# Load and prepare data ------------------------------------------------------
nog <- read.csv("allNOG.csv")
tax_sum <- read.table("tax_vs_ko.txt", header = TRUE)
tax_pas <- read.table("ppen_tax_vs_ko.txt.txt", header = TRUE)

# Remove PPEN annotations which DO NOT match ENA flatfile identifiers
tax_sum <- tax_sum[!grepl("PPEN", tax_sum$TAX), ]
# Replace with PPEN annotations which DO match ENA flatfile identifiers
tax_sum <- rbind(tax_sum, tax_pas)

# get a count of each KO in each taxa
tax_ko_table <- tax_sum %>% count(TAX, KO)

# Convert from long to wide format
tax_wide <- spread(tax_ko_table, KO, n)
#write.csv(tax_wide, "tax_wide.csv")
row.names(tax_wide) <- tax_wide$TAX

# Set missing values to zero and any count greater than zero to one to give 
#  a boolean presence/abscence matrix
tax_wide[is.na(tax_wide)] <- 0
for (x in 2:ncol(tax_wide)) {
  tax_wide[,x] <- ifelse(tax_wide[,x]>0,1,0)
}
#write.csv(tax_wide, "binary.taxa.vs.KO.csv")

# Principal component analysis -----------------------------------------------
# Compute a PCA of KO presence abscence for each species.
meta_pca <- prcomp(tax_wide[,2:6526])

# Visualise eigenvalues. Percentage of variances explained by each principal component. 
fviz_eig(meta_pca)

# Plot PCA 
autoplot(prcomp(tax_wide[,2:6526]),
         data = tax_wide,
         label = TRUE,
         shape = FALSE)

# ALternative PCAs
fviz_pca_ind(meta_pca,
             col.ind = "cos2", 
             gradient.cols = c ("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE,
             label = TRUE)

fviz_pca_var(meta_pca,
             col.var = "contrib", 
             select.var = list(contrib=50),
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE)

fviz_pca_biplot(meta_pca,
                col.var = "contrib",
                select.var=list(cos2=50),
                gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
                repel = TRUE)


## Save PCA
#ggsave("metapca.svg", dpi=1200)

# Genrate an intersect plot --------------------------------------------------
row.names(tax_wide)
colnames(tax_wide)
bin.tax_wide <- tax_wide[,-1]

row.names(bin.tax_wide) <- row.names(tax_wide)
row.names(bin.tax_wide)

t.tax.wide<- t(bin.tax_wide)
t.tax.wide <-as.data.frame(t.tax.wide)
row.names(t.tax.wide)
colnames(t.tax.wide)
setnames <- colnames(t.tax.wide)
setnames

upset(t.tax.wide, order.by = "freq", nintersects = 20, sets = c("PPEN",
                                                                "WBAN",
                                                                "WBMA",
                                                                "WOOC",
                                                                "WOVO",
                                                                "XIPH",
                                                                "XNEM",
                                                                "YPSE",
                                                                "PHET",
                                                                "CNEM"))

upset(t.tax.wide, order.by = "freq", nintersects = 50, sets = c("PPEN",
                                                                "TVUL",
                                                                "SPEP",
                                                                "LTHE",
                                                                "RMAS",
                                                                "SKRI",
                                                                "TDIC",
                                                                "TDAQ",
                                                                "LSED"))

# Pull out intersects --------------------------------------------------------
colnames(t.tax.wide)

overlaps <- t.tax.wide
overlaps$numtax <- rowSums(t.tax.wide)

common <- overlaps[overlaps$numtax > 90, ]
write.csv(common, "common.kos.csv")
rare <- overlaps[overlaps$numtax < 20, ]
write.csv(rare, "rare.kos.csv")

pas.only <- subset(overlaps, numtax==1 &
                     PPEN==1)
write.csv(pas.only, "pas_unique_kos.csv")

# Identify 9 KOs unique to Pasteuria within thermoactinomycetae
pas_thermo_unique <- subset(overlaps, PPEN==1 &
                            TVUL==0 &
                            SPEP==0 &
                            LTHE==0 &
                            RMAS==0 &
                            SKRI==0 &
                            TDIC==0 &
                            TDAQ==0 &
                            LSED==0)
write.csv(pas_thermo_unique, "pas_thermo_unique.csv")

# Identify 410 KOs uniquely absent from P. penetrans compared to
# Thermoactinomycetae
pas_thermo_missing <- subset(overlaps, PPEN==0 &
                              TVUL==1 &
                              SPEP==1 &
                              LTHE==1 &
                              RMAS==1 &
                              SKRI==1 &
                              TDIC==1 &
                              TDAQ==1 &
                              LSED==1)

pas_thermo_shared <- subset(overlaps, PPEN==1 &
                               TVUL==1 &
                               SPEP==1 &
                               LTHE==1 &
                               RMAS==1 &
                               SKRI==1 &
                               TDIC==1 &
                               TDAQ==1 &
                               LSED==1)

pas_spep_shared_abscence <- subset(overlaps, PPEN==0 &
                              TVUL==1 &
                              SPEP==0 &
                              LTHE==1 &
                              RMAS==1 &
                              SKRI==1 &
                              TDIC==1 &
                              TDAQ==1 &
                              LSED==1)

pas_skri_tdic_shared_abscence <- subset(overlaps, PPEN==0 &
                                     TVUL==1 &
                                     SPEP==1 &
                                     LTHE==1 &
                                     RMAS==1 &
                                     SKRI==0 &
                                     TDIC==0 &
                                     TDAQ==1 &
                                     LSED==1)


write.csv(pas_thermo_shared, "pas_thermo_shared_by_all.csv")
write.csv(pas_spep_shared_abscence, "pas_spep_shared_abscence.csv")
write.csv(pas_skri_shared_abscence, "pas_skri_shared_abscence.csv")
write.csv(pas_skri_tdic_shared_abscence, "pas_skri_tdic_shared_abscence.csv")


# From total annotations subset nearest relative
spep_annotations <- nog[grepl("SPEP.", nog$query_name), ]

# Create a list of missing KEGG IDs
thermo_miss_list <- rownames(pas_thermo_missing)

# Pull out full annotations for missing KOs
thermo_miss_anno <- spep_annotations[grep(paste(thermo_miss_list, collapse = "|"),
                      spep_annotations$KEGG_ko), ]
# Write out full annotations
write.csv(thermo_miss_anno, "ppen_missing_present_all_thermo.csv")

# Get a count of COG functional category for each missing annotation 
COG_count <- thermo_miss_anno %>% count(COG.Functional.Category)
COG_count
write.csv(COG_count, "COG_missing_ppen_thermo.csv")

# sanity check compare to Bacillus subtilis
rare.abscence.bsub <- subset(overlaps, BSUB==0 &
                               numtax > 90)
rare.presence.bsub <- subset(overlaps, BSUB==1 &
                               numtax < 20)

# subset P.penetrans annotations from total eggNOG annotations
ppen_annotations <- nog[grepl("PPEN.", nog$query_name), ]


ppen.transposase <- ppen[grepl("Transposase",
                               ppen$eggNOG_description,
                               ignore.case = TRUE), ]
#write.csv(ppen.transposase, "PPEN_transposases.csv")

total.transposase <- nog[grepl("Transposase",
                               nog$eggNOG_description,
                               ignore.case = TRUE), ]

trantab <- read.csv("tax.vs.tran.csv")
# count transposases per genome
tax_transposase_table <- trantab %>% count(TAX, TRAN)
