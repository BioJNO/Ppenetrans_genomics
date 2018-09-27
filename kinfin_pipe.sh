cd /home/jo42324/pas-genomics/assembly_update/kinfin

mkdir sane_proteins/

cd sane_proteins/

~/kinfin/scripts/filter_fastas_before_clustering.py -f ../BCER.Bacillus_cereus.faa > BCER.Bacillus_cereus.sl.faa
wait
~/kinfin/scripts/filter_fastas_before_clustering.py -f ../BTHU.Bacillus_thuringiensis.faa > BTHU.Bacillus_thuringiensis.sl.faa
wait
~/kinfin/scripts/filter_fastas_before_clustering.py -f ../PPEN.Pasteuria_penetrans.faa > PPEN.Pasteuria_penetrans.sl.faa
wait
~/kinfin/scripts/filter_fastas_before_clustering.py -f ../BSUB.Bacillus_subtilis.faa > BSUB.Bacillus_subtilis.sl.faa
wait
~/kinfin/scripts/filter_fastas_before_clustering.py -f ../CDIF.Clostridioides_difficile.faa > CDIF.Clostridioides_difficile.sl.faa
wait
~/kinfin/scripts/filter_fastas_before_clustering.py -f ../TVUL.Thermoactinomyces_vulgaris.faa > TVUL.Thermoactinomyces_vulgaris.sl.faa
wait

# RASTtk can put pipe characters in the names which will mess up Kinfin further down the pipe
sed -i -e 's/|/_/g' *.sl.faa

cd ..

orthoday=$(date -d "$D" '+%b%d')

orthofinder -t 16 -n orthofinderout -f sane_proteins/
wait

cd sane_proteins/

cat *.faa > all_proteins.faa
wait

mkdir interpro_output

bash interproscan.sh \
	-i all_proteins.faa \
	-d interpro_output/ \
	-dp \
	-pa \
	-t p \
	--goterms \
	--cpu 16 \
	-f TSV
wait

echo '#IDX,TAXON' > config.txt
sed 's/: /,/g' Results_orthofinderout_$orthoday/WorkingDirectory/SpeciesIDs.txt | \
	cut -f 1 -d"." \
	>> config.txt

wait

~/kinfin/scripts/iprs2table.py -i interpro_output/all_proteins.faa.tsv \
--domain_sources TIGRFAM,\
SFLD,\
SUPERFAMILY,\
PANTHER,\
Gene3D,\
Hamap,\
Coils,\
ProSiteProfiles,\
SMART,\
CDD,\
PRINTS,\
ProSitePatterns,\
Pfam,\
ProDom,\
MobiDBLite,\
PIRSF 

wait 

mkdir fasta/
mv *sl.faa fasta/

wait

kinfin -g Results_orthofinderout_$orthoday/Orthogroups.txt \
-c config.txt \
-s Results_orthofinderout_$orthoday/WorkingDirectory/SequenceIDs.txt \
-p Results_orthofinderout_$orthoday/WorkingDirectory/SpeciesIDs.txt \
-a fasta \
-f functional_annotation.txt 

wait 

cd kinfin_results/

~/kinfin/scripts/functional_annotation_of_clusters.py all -f cluster_domain_annotation.IPR.txt -c TAXON/TAXON.cluster_summary.txt
