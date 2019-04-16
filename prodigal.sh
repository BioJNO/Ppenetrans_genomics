cd /home/jo42324/scratch/pas-genomics/finalassembly/fasta/

for f in *.fasta
do
	prodigal \
	-a ../../genepredictions/"${f/%.fasta/.faa}" \
	-q -i "$f"
done
