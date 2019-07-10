# Analyse all P. penetrans assemblies with bacteria, firmicute, and bacilli 
# marker sets 
checkm analyze -x fasta -t 8 ../bacteria.ms ./all_assemblies/ ./checkm_bact/ 
wait

checkm analyze -x fasta -t 8 ../firmicutes.ms ./all_assemblies/ ./checkm_firm/ 
wait

checkm analyze -x fasta -t 8 ../bacilli.ms ./all_assemblies/ ./checkm_bacilli/ 
wait

# Generate a table for each marker set with extended statistics
checkm qa -o 2 --tab_table -f bact-analyse-extended.txt ../bacteria.ms \
./checkm_bact/
wait

checkm qa -o 2 --tab_table -f firm-analyse-extended-pilon.txt ../firmicutes.ms \
./checkm_firm/
wait

checkm qa -o 2 --tab_table -f bacilli-analyse-exended-pilon.txt ../bacilli.ms \
./checkm_bacilli/
wait 

# Generate a histogram of completeness, heterogeneity, and contamination
checkm bin_qa_plot -x fasta --image_type svg ./checkm_bact/ ./all_assemblies/ \
./checkm_bact/plots
