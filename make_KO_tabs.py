
# create a table of tax code and KO numbers and a table of
# genes vs KO numbers suitable for KEGG Mapper:
# https://www.genome.jp/kegg/tool/map_pathway.html

infile = open("PPEN.emapper.annotations", "r")
outfile1 = open("ppen_tax_vs_ko.txt", "w")
outfile2 = open("ppen_gene_vs_ko.txt", "w")

outfile1.write("TAX\tKO\n")
outfile2.write("#GENE\tKO\n")

for line in infile:
    if not line.startswith("#"):
        linesplit = line.split("\t")
        gene = linesplit[0]
        taxsplit = gene.split(".")
        tax = taxsplit[0]
        gene_id = taxsplit[1]
        for column, content in enumerate(linesplit):
            if content.startswith("ko:"):
                KOs = linesplit[column]
                kosplit = KOs.split(",")
                if "ko" not in KOs:
                    print("no KO for gene name: " + gene_id)
                elif len(kosplit) == 1:
                    outfile1.write(tax + "\t" + KOs + "\n")
                    outfile2.write(gene_id + "\t" + KOs + "\n")
                elif len(kosplit) > 1:
                    for ko in enumerate(kosplit):
                        outfile1.write(tax + "\t" + ko[1] + "\n")
                        outfile2.write(gene_id + "\t" + ko[1] + "\n")

outfile1.close()
outfile2.close()
