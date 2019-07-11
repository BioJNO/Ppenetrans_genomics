samtools view -b -@ 8 \
-o bowtie_new_illumina_ccs.pacasus.arrow.circ.pilon_unaligned_pairs_map.bam \
bowtie_new_illumina_ccs.pacasus.arrow.circ.pilon_unaligned_pairs_map.sam

samtools sort -@ 8 \
-o bowtie_new_illumina_ccs.pacasus.arrow.circ.pilon_unaligned_pairs_map_sorted.bam \
bowtie_new_illumina_ccs.pacasus.arrow.circ.pilon_unaligned_pairs_map.bam

samtools index bowtie_new_illumina_ccs.pacasus.arrow.circ.pilon_unaligned_pairs_map_sorted.bam 
