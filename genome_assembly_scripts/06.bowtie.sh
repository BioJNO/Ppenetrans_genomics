set -e


bowtie2-build --verbose ccs_pacasus_circ.fasta PPRES148
wait

# Align paired reads
bowtie2 -p 8 \
--very-sensitive \
--al-conc illumina_pac.ccs.arrow.circ.pilon_aligned_paired.fastq \
--un-conc illumina_pac.ccs.arrow.circ.pilon_unaligned_paired.fastq \
-x PPRES148 \
-1 /mnt/shared/projects/pasteuria/201706_Pasteuria_PacBio/raw_data/07042019_Illumina/20190212_Orr1/reads/23336_PpenRES148_1_trimmed.fastq.gz  \
-2 /mnt/shared/projects/pasteuria/201706_Pasteuria_PacBio/raw_data/07042019_Illumina/20190212_Orr1/reads/23336_PpenRES148_2_trimmed.fastq.gz  \
-S bowtie_new_illumina_ccs.pacasus.arrow.circ.pilon__paired_map.sam

# Align unpaired reads
bowtie2 -p 8 \
--very-sensitive \
--un illumina_pac.ccs.arrow.circ.pilon_unaligned_unpaired.fastq \
--al illumina_pac.ccs.arrow.circ.pilon_aligned_unpaired.fastq \
-x PPRES148 \
-U /mnt/shared/projects/pasteuria/201706_Pasteuria_PacBio/raw_data/07042019_Illumina/20190212_Orr1/reads/23336_PpenRES148_U1_trimmed.fastq.gz \
-U /mnt/shared/projects/pasteuria/201706_Pasteuria_PacBio/raw_data/07042019_Illumina/20190212_Orr1/reads/23336_PpenRES148_U2_trimmed.fastq.gz \
-S bowtie_new_illumina_ccs.pacasus.arrow.circ.pilon_unpaired_map.sam

# Align pairs which did not align initially as unpaired reads
bowtie2 -p 8 \
--very-sensitive \
--un illumina_pac.ccs.arrow.circ.pilon_unaligned_paired_unaligned.fastq \
--al illumina_pac.ccs.arrow.circ.pilon_unaligned_paired_aligned.fastq \
-x PPRES148 \
-U illumina_pac.ccs.arrow.circ.pilon_unaligned_paired.1.fastq \
-U illumina_pac.ccs.arrow.circ.pilon_unaligned_paired.2.fastq \
-S bowtie_new_illumina_ccs.pacasus.arrow.circ.pilon_unaligned_pairs_map.sam
