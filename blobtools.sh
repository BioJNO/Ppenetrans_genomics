# Get taxonomic data for contigs------------------------------- 
# BLAST
export BLASTDB=/mnt/shared/cluster/databases/ncbi/extracted
blastn \
 -query contigs.fasta \
 -db nt \
 -outfmt '6 qseqid staxids bitscore' \
 -max_target_seqs 10 \
 -max_hsps 1 \
 -evalue 1e-25 \
 -num_threads 8 \
 -out unmapped.illuminapairassembly.blastn.txt
wait 

# Create a BlobDB-----------------------------------------------
blobtools create \
-y spades \
-i contigs.fasta \
-t unmapped.illuminapairassembly.blastn.txt \
-o ./unmapped.illumina.blobdb
wait

# Generate a tabular view----------------------------------------
blobtools view -i ././unmapped.illumina.blobdb.blobDB.json -r genus

wait
# Generate a blobplot--------------------------------------------
blobtools blobplot -i ././unmapped.illumina.blobdb.blobDB.json -r genus --format svg 