# Load data ------------------------------------------------------------------
clustersummary <- read.csv("TAXON.cluster_summary.csv")
annotation <- read.csv("cluster_functional_annotation.all.p75.x75.csv")

# Merge the functional annotations with the cluster stats file.
merged <- merge(clustersummary, annotation, by = "X.cluster_id")

# Write out hte merged cluster functional summary.
write.csv(merged, "sporeset_merged.csv")

# Subset sporulation clusters ------------------------------------------------
# Create a list of sporulation terms to pull from functional annotations.
sporeterms <- c("spore",
                "sporulation",
                "cot",
                "coat",
                "sinI",
                "sinR",
                "SASP",
                "SSP",
                "spo",
                "exs")

# Subset clusters with spore terms included in functional annotations.
subsetspore <- merged[grep(paste(sporeterms, collapse = "|"),
                                 merged$domain_description,
                                 ignore.case = TRUE), ]

# Create a list of false positive terms to exclude.
exclterms <- c("transport",
               "response",
               "transpos",
               "respo",
               "nicot")

# Store clusters to be exluded as false positives in a data frame.
exclsubset <- subsetspore[grep(paste(exclterms, collapse = "|"),
                                     subsetspore$domain_description,
                                     ignore.case = TRUE), ]

# Remove suspected false positive clusters from sporulation subset.
subsetspore <- subsetspore[!grepl(paste(exclterms, collapse = "|"),
                                        subsetspore$domain_description,
                                        ignore.case = TRUE), ]

# Create a list of reduced spore terms.
reducedsporeterms <- c("spore",
                       "sporulation",
                       "coat",
                       "sinI",
                       "sinR",
                       "SASP",
                       "SSP",
                       "exs")

# Look in suspected false positives for positives.
exclfalseneg <- exclsubset[grep(paste(reducedsporeterms, collapse = "|"),
                                      exclsubset$domain_description,
                                      ignore.case = TRUE), ]

# Write out clusters which should not be removed as false positives.
write.csv(exclfalseneg, "false-removal.csv")

# Join spore subset table with recovered clusters
# incorrectly flagged as false positives.
totalsporetab <- rbind(subsetspore, exclfalseneg)

# Write out sporulation cluster table.
write.csv(totalsporetab, "sporulation_subset.csv")

# Look for SinI and SinR explicitly in all proteomes -------------------------
# Store SinI and SinR in a list.
sinterms <- c("sinI", "sinR")

# Look for SinI and SinR in sporulation functional annotations.
# Store as a data frame.
sin_sub <- totalsporetab[grep(paste(sinterms, collapse = "|"),
                                    totalsporetab$domain_description,
                                    ignore.case = TRUE), ]

# Write out SinI/SinR cluster table.
write.csv(sin_sub, "sin_subset.csv")
