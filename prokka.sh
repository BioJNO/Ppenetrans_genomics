#!/bin/bash
set -euo pipefail
# See http://redsymbol.net/articles/unofficial-bash-strict-mode/

cd /home/jo42324/pas-genomics/assembly_update/

prokka --outdir gene_prediction/prokka --force --prefix "smrtcell2_cov200" \
--genus "Pasteuria" --species "penetrans" --strain RES148 --addgenes \
fasta/smrtcell1_cov200.fasta

