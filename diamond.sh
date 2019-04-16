#!/bin/bash
#set -e

cd /home/jo42324/scratch/pas-genomics/finalassembly/genepredictions/

for f in *.faa
do
	diamond blastp --threads 16 \
	--max-target-seqs 1 \
	--db /mnt/shared/cluster/databases/diamond/nr.dmnd \
	--query "$f" \
	--outfmt 6 qlen slen \
	--out ../ideel/"$f".data
done
