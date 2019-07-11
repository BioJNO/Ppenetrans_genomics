from Bio.SeqIO.FastaIO import SimpleFastaParser

fastahandle = open("all_ccs.subreads.fasta")

outfile1 = open("ccs.group1.fasta", "w")
outfile2 = open("ccs.group2.fasta", "w")
outfile3 = open("ccs.group3.fasta", "w")
outfile4 = open("ccs.group4.fasta", "w")
outfile5 = open("ccs.group5.fasta", "w")
outfile6 = open("ccs.group6.fasta", "w")
outfile7 = open("ccs.group7.fasta", "w")
outfile8 = open("ccs.group8.fasta", "w")
outfile9 = open("ccs.group9.fasta", "w")
outfile10 = open("ccs.group10.fasta", "w")
outfile11 = open("ccs.group11.fasta", "w")
outfile12 = open("ccs.group12.fasta", "w")
outfile13 = open("ccs.group13.fasta", "w")
outfile14 = open("ccs.group14.fasta", "w")
outfile15 = open("ccs.group15.fasta", "w")
outfile16 = open("ccs.group16.fasta", "w")
outfile17 = open("ccs.group17.fasta", "w")
outfile18 = open("ccs.group18.fasta", "w")
outfile19 = open("ccs.group19.fasta", "w")
outfile20 = open("ccs.group20.fasta", "w")
outfile21 = open("ccs.group21.fasta", "w")

for title, seq in SimpleFastaParser(fastahandle):
    seqlen = len(seq)
    if seqlen < 2000:
        outfile1.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 3000:
        outfile2.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 4000:
        outfile3.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 5000:
        outfile4.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 6000:
        outfile5.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 7000:
        outfile6.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 8000:
        outfile7.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 9000:
        outfile8.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 10000:
        outfile9.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 11000:
        outfile10.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 12000:
        outfile11.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 13000:
        outfile12.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 14000:
        outfile13.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 15000:
        outfile14.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 16000:
        outfile15.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 17000:
        outfile16.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 18000:
        outfile17.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 19000:
        outfile18.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 20000:
        outfile19.write(">%s\n%s\n" % (title, seq))
    elif seqlen < 21000:
        outfile20.write(">%s\n%s\n" % (title, seq))
    else:
        outfile21.write(">%s\n%s\n" % (title, seq))

