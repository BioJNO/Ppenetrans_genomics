cd /home/jo42324/pas-genomics/all_assembly/

checkm lineage_wf -x fasta -t 8 -f lineage_wf_out.txt --tab_table --pplacer_threads 8 fasta/ checkm_output2

cd checkm/

checkm qa -o 9 -f markers.fasta checkm_output/lineage.ms checkm_output/ 