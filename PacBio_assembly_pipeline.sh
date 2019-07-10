set -e

cd /home/jo42324/pas-genomics/canu_cov200_smrtcell1

echo "Starting canu assembly"

canu -p pas-pen-res148 -d pcbio-assembly genomeSize=2.7m corOutCoverage=200 -pacbio-raw  \
"/home/jo42324/pas-genomics/seqdata/all_reads.fastq" \
-useGrid=False -maxMemory=230 -maxThreads=16

wait

echo "Canu finished"

wait

mkdir finisher

echo "Converting fastq raw subreads to fasta for finisher."

fastq-to-fasta /home/jo42324/pas-genomics/seqdata/all_reads.fastq

wait

echo "Renaming files for Finisher"

cp pcbio-assembly/pas-pen-res148.contigs.fasta contigs.fasta
mv all_reads.fasta raw_reads.fasta
mv raw_reads.fasta finisher/
mv contigs.fasta finisher/

wait

cd finisher/

echo "Running finsher on unpolished assembly."

python ~/Download/finishingTool/finisherSC.py /home/jo42324/pas-genomics/canu_cov200_smrtcell1/finisher /mnt/shared/scratch/synology/jo42324/apps/conda/bin/ 

wait

echo "Indexing finisher improved assembly with samtools."

samtools faidx improved3.fasta

wait

echo "converting bax.h5 to bam with bax2bam"

bax2bam /home/jo42324/pas-genomics/seqdata/Project_2017_06_21_jamie_orr_gdna_rsi_symlinks/REPLI-G_PASTEURIA_PENETRANS_RES148/2017run11_343/G09_1/Analysis_Results/smrtcell1.all.bax.h5 -o total --subread

echo "Aligning reads to finisher assembly with pbalign."

pbalign total.subreads.bam improved3.fasta pbaligned.bam

wait

echo "Running arrow error correction on finisher assembly"

/mnt/shared/scratch/synology/jo42324/apps/smrtanalysis_v4.0.0/smrtlink/smrtcmds/bin/arrow --verbose -j 16 --annotateGFF --referenceFilename improved3.fasta -o consensus.fasta pbaligned.bam
wait

echo "Fin."
