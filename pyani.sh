cd /home/jo42324/pas-genomics/assembly_update/pyani

average_nucleotide_identity.py --labels fastareduced/labels.txt --maxmatch -l ANImlog.txt -v -g --gformat svg -o ANImMaxmatch -i fastareduced/
wait

average_nucleotide_identity.py --labels fastareduced/labels.txt -m ANIb -l ANIblog.txt -v -g --gformat svg -o ANIb -i fastareduced/