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
pen_nog <- read.csv("PPEN.eggNOG.csv")

# Remove PPEN annotations which DO NOT match ENA flatfile identifiers
tax_sum <- tax_sum[!grepl("PPEN", tax_sum$TAX), ]
nog <- nog[!grepl("PPEN.", nog$query_name),]

# Replace with PPEN annotations which DO match ENA flatfile identifiers
tax_sum <- rbind(tax_sum, tax_pas)
nog <- rbind(nog, pen_nog)
colnames(nog)
colnames(pen_nog)

write.csv(nog, "all_eggnog_annotations.csv")
write.table(tax_sum, "tax_vs_ko_table.txt")

# get a count of each KO in each taxa
tax_ko_table <- tax_sum %>% count(TAX, KO)

# Convert from long to wide format
tax_wide <- spread(tax_ko_table, KO, n)
#write.csv(tax_wide, "tax_wide.csv")
row.names(tax_wide) <- tax_wide$TAX

# Set missing values to zero and any count greater than zero to one to give 
#  a boolean presence/abscence matrix
for (x in 2:ncol(tax_wide)) {
  tax_wide[,x] <- ifelse(tax_wide[,x]>0,0,0)
}
tax_wide[is.na(tax_wide)] <- 1
#write.csv(tax_wide, "binary.taxa.vs.KO.csv")

# create an intersect plot of missing KOs ------------------------------------
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

upset(t.tax.wide, order.by = "freq", nintersects = 20, sets = c("PPEN",
                                                                "TVUL",
                                                                "SPEP",
                                                                "LTHE",
                                                                "RMAS",
                                                                "SKRI",
                                                                "TDIC",
                                                                "TDAQ",
                                                                "LSED",
                                                                "WBAN",
                                                                "WBMA",
                                                                "WOOC",
                                                                "WOVO",
                                                                "XIPH",
                                                                "XNEM",
                                                                "YPSE",
                                                                "PHET",
                                                                "CNEM"))

overlaps <- t.tax.wide
overlaps$numtax <- rowSums(t.tax.wide)

pen_wolb_xnem_vs_spep_absent <- subset(overlaps, PPEN==1 &
                                         SPEP==0 &
                                         WBAN==1 &
                                         WBMA==1 &
                                         WOOC==1 &
                                         WOVO==1 &
                                         XIPH==1)

pen_wolb_xnem_vs_spep_absent <- subset(overlaps, PPEN==1 &
                                         SPEP==0 &
                                         WBAN==1 &
                                         WBMA==1 &
                                         WOOC==1 &
                                         WOVO==1 &
                                         XIPH==1)

write.csv(pen_wolb_xnem_vs_spep_absent, "pen_wolb_xnem_vs_spep_absent.csv")

pen_nog_flag <- pen_nog[grepl("pyruvate", pen_nog$eggNOG_description, ignore.case = TRUE),]
