
for f in *.fasta
do
	prodigal \
	-a ../../genepredictions/"${f/%.fasta/.faa}" \
	-q -i "$f"
done
