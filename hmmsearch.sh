
set -e 

#cd /home/jo42324/pas-genomics/assembly_update/gene_prediction/prokka

#hmmsearch --cut_ga --domtblout collagens/prokka_collagens.out \
#collagens/Collagen.hmm \
#smrtcell2_cov200.faa

#wait

cd /home/jo42324/pas-genomics/assembly_update/gene_prediction/classic_rast

hmmsearch --cut_ga --domtblout collagens/classic_rast_collagens.out \
collagens/Collagen.hmm \
classic_rast.faa

wait 

cd /home/jo42324/pas-genomics/assembly_update/gene_prediction/rast_tk

hmmsearch --cut_ga --domtblout collagens/Rast_tk_collagens.out \
collagens/Collagen.hmm \
Rast_tk.faa

