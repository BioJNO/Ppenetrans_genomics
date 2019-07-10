# Given folder of genomes as contigs with extension .fna

# Analyse completeness and contamination against bacterial marker HMMs
checkm analyze -x fna -t 8 \
../bacteria.ms ./fna ./checkm_bact/

# Firmicute HMMs
checkm analyze -x fna -t 8 \
../firmicutes.ms ./pilon ./checkm_firm/

# Bacilli HMMs
checkm analyze -x fna -t 8 \
../bacilli.ms ./pilon/ ./checkm_bacilli/ 

# Generate stats for each marker set
checkm qa -o 9 -f bact-markers.fasta ../bacteria.ms ./checkm_bact/
checkm qa -o 9 -f firm-markers.fasta ../firmicutes.ms ./checkm_firm/
checkm qa -o 9 -f bacilli-markers.fasta ../bacilli.ms ./checkm_bacilli/

# Generate qa plot of bacterial marker stats 
# N.B bin_qa_plot slightly modified for colour blind friendly figures
checkm bin_qa_plot -x fna --image_type svg \
./checkm_bact/ \
./fna \
./checkm_bact/plots



