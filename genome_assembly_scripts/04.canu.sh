canu -p pas-pen-res148 \
-d canu1.5 genomeSize=2.5m corOutCoverage=50 \
-pacbio-corrected  \
"/mnt/shared/projects/pasteuria/201706_Pasteuria_PacBio/raw_data/ccs/all.smrtcell.ccs.fastq" \
-useGrid=False \
-maxMemory=230 \
-maxThreads=16 \
-gnuplotTested=TRUE

