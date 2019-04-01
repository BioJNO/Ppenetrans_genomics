cd /home/jo42324/scratch/pas-genomics/finalassembly/kinfin_pipeline_test/contigs/

# Check for all executables ----------------------------------------------------------------------
echo Checking for required executables in path ---------------------------------------------------
for name in orthofinder kinfin interproscan.sh prodigal filter_fastas_before_clustering.py
do 
    path_to_ex=$(which "$name")
    if [ -x "$path_to_ex" ] ; then
        echo ""$name" is here: $path_to_ex"
    else
        echo "WARNING:"$name" not found! Please install it and/or add the directory to your path."
        exit
    fi
done 2>/dev/null

# Check for panther data -------------------------------------------------------------------------
path_to_interproscan=$(which interproscan.sh)
DIR=$(dirname "${path_to_interproscan}")
if [ -d "${DIR}"/data/panther/ ]; then
    echo Panther data found
else
    echo Panther data not found. You may need to download it or \
    make changes to the interproscan command further down
fi 2>/dev/null

# for all contig fasta files in directory predict genes using prodigal ----------------------------
echo Running prodigal on contig fasta files -------------------------------------------------------
mkdir predicted_proteins
for f in *.fna
do
    prodigal \
    -a predicted_proteins/"${f/%.fna/.faa}" \
    -o predicted_proteins/"${f/%.fna/.gbk}" \
    -q -i "$f" || { echo 'Prodigal failed!' ; exit 1; }
done
wait

# filter predicted proteins -----------------------------------------------------------------------
echo Filtering predicted proteins -----------------------------------------------------------------
cd predicted_proteins/
mkdir ../sane_proteins/
for f in *.faa
do 
    filter_fastas_before_clustering.py \
    -f "$f" > ../sane_proteins/"${f/%.faa/.sl.faa}"
done

# RASTtk can put pipe characters in the names which will mess up Kinfin further down the pipe
# if using RASTtk remove pipe characters with sed:
#sed -i -e 's/|/_/g' *.sl.faa

# Run orthofinder ---------------------------------------------------------------------------------
echo Running orthofinder on filtered proteins -----------------------------------------------------
cd ..
orthoday=$(date -d "$D" '+%b%d')
orthofinder -t 16 -n orthofinderout -f sane_proteins/ || { echo 'Orthofinder failed!' ; exit 1; }
wait

# Concatenate all protein predictions and remove asterisks ----------------------------------------
echo Concatenating protein predictions and removing asterisks -------------------------------------
cd sane_proteins/
sed -i -e 's/*//g' *.faa
cat *.faa > ../all_proteins.faa

# Run interproscan --------------------------------------------------------------------------------
echo Running interproscan on all filtered proteins ------------------------------------------------
cd ..
mkdir interpro_output
bash interproscan.sh \
    -i all_proteins.faa \
    -d interpro_output/ \
    -dp \
    -pa \
    -t p \
    --goterms \
    --cpu 16 \
    -f TSV ||{ echo 'interproscan failed!' ; exit 1; }
wait

# Make a kinfin config file -----------------------------------------------------------------------
echo Making a kinfin config file ------------------------------------------------------------------
echo '#IDX,TAXON' > config.txt
sed 's/: /,/g' Results_orthofinderout_$orthoday/WorkingDirectory/SpeciesIDs.txt | \
    cut -f 1 -d"." \
    >> config.txt
wait

# Convert interproscan output to format for kinfin ------------------------------------------------
echo Converting interproscan output for kinfin ----------------------------------------------------
iprs2table.py -i interpro_output/all_proteins.faa.tsv \
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

# Run kinfin -----------------------------------------------------------------------------------
echo Running Kinfin ----------------------------------------------------------------------------
kinfin -g Results_orthofinderout_$orthoday/Orthogroups.txt \
-c config.txt \
-s Results_orthofinderout_$orthoday/WorkingDirectory/SequenceIDs.txt \
-p Results_orthofinderout_$orthoday/WorkingDirectory/SpeciesIDs.txt \
-a sane_proteins \
-f functional_annotation.txt || { echo 'KinFin failed!' ; exit 1; }
wait 

# Generate a funtional annotation of clusters file ---------------------------------------------
echo Generating cluster funtional annotation file ----------------------------------------------
cd kinfin_results/
functional_annotation_of_clusters.py all \
-f cluster_domain_annotation.IPR.txt \
-c TAXON/TAXON.cluster_summary.txt
