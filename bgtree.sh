
set -e 

cd /home/jo42324/pas-genomics/assembly_update/phylogeny_root

perl /home/jo42324/Download/bcgTree/bin/bcgTree.pl \
--proteome Escherichia_coli=ECOL.Esherichia_coli.faa \
--proteome Pasteria_penetrans=PPEN.Pasteuria_penetrans.faa \
--proteome Bacillus_anthracis=BANT.Bacillus_anthracis.faa \
--proteome Bacillus_cereus=BCER.Bacillus_cereus.faa \
--proteome Bacillus_halodurans=BHAL.Bacillus_halodurans.faa \
--proteome Bacillus_subtilis=BSUB.Bacillus_subtilis.faa \
--proteome Bacillus_thuringiensis=BTHU.Bacillus_thuringiensis.faa \
--proteome Thermoactinomyces_vulgaris=TVUL.Thermoactinomyces_vulgaris.faa \
--proteome Caldanaerobacter_subterraneus=CSUB.Caldanaerobacter_subterraneus.faa \
--proteome Clostridium_botulinum=CBOT.Clostridium_botulinum.faa \
--proteome Clostidioides_difficile=CDIF.Clostridioides_difficile.faa \
--proteome Dubosiella_newyorkensis=DNEW.Dubosiella_newyorkensis.faa \
--proteome Enterococcus_faecialis=EFAE.Enterococcus_faecialis.faa \
--proteome Lactobacillus_acidophilus=LACI.Lactobacillus_acidophilus.faa \
--proteome Pelosinus_UFO1=PUFO.Pelosius_UFO1.faa \
--proteome Sporanaerobacter_acetigenes=SACE.Sporanaerobacter_acetigenes.faa \
--proteome Thermoanaerobacter_brockii=TBRO.Thermoanaerobacter_brockii.faa \
--proteome Kropenstedtia_eburnea=KEBU.Kropenstedtia_eburnea.faa \
--proteome Novibacillus_thermophilus=NTHE.Novibacillus_thermophilus.faa \
--outdir treeout \
--threads=8



