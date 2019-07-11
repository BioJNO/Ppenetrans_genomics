for f in *.fna
do
    barrnap \
    --outseq "${f/%.fna/.16s.fasta}" \
    "$f"
done
