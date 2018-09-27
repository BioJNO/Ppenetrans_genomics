cd /home/jo42324/rothamsted-genomic-assembly/rothamsted-assembly/MIRA_assemblies/2ndMiraAssemby

mkdir repblobs/

# Create a BlobDB #
blobtools create -i black1-accurate-v13.fasta \
-c black1-accurate-v13.bam.cov \
-t Black1.MIRA.firmicute.assembly.v13.vs.nt.25cul1.1e25.megablast.out \
-o repblobs/13thMIRA_assembly
wait 

cd repblobs/

# Generate a tabular view #
blobtools view -i 13thMIRA_assembly.blobDB.json -r genus

wait
# Generate a blobplot #
blobtools blobplot -i 13thMIRA_assembly.blobDB.json -r genus --format svg 