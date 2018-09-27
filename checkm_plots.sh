#usage: checkm bin_qa_plot [-h] [--image_type {eps,pdf,png,ps,svg}] [--dpi DPI]
#                          [--font_size FONT_SIZE] [-x EXTENSION]
#                          [--width WIDTH] [--row_height ROW_HEIGHT]
#                          [--ignore_hetero] [--aai_strain AAI_STRAIN] [-q]
#                          out_folder bin_folder plot_folder
#
#Bar plot of bin completeness, contamination, and strain heterogeneity.
#
#positional arguments:
#  out_folder            folder specified during qa command
#  bin_folder            folder containing bins to plot (fasta format)
#  plot_folder           folder to hold plots
#
#optional arguments:
#  -h, --help            show this help message and exit
#  --image_type {eps,pdf,png,ps,svg}
#                        desired image type (default: png)
#  --dpi DPI             desired DPI of output image (default: 600)
#  --font_size FONT_SIZE
#                        Desired font size (default: 8)
#  -x, --extension EXTENSION
#                        extension of bins (other files in folder are ignored) (default: fna)
#  --width WIDTH         width of output image (default: 6.5)
#  --row_height ROW_HEIGHT
#                        height of each row in the output image (default: 0.3)
#  --ignore_hetero       do not plot strain heterogeneity
#  --aai_strain AAI_STRAIN
#                        AAI threshold used to identify strain heterogeneity (default: 0.9)
#  -q, --quiet           suppress console output
#
#Example: checkm bin_qa_plot ./output ./bins ./plots

cd /home/jo42324/pas-genomics/all_assembly/

checkm bin_qa_plot -x fasta ./checkmout_two/ \
./ \
./checkm_output2/plots

checkm gc_plot -x fasta \
./ \
./checkmout_two/plots 95

checkm coding_plot -x fasta ./checkmout_two/ \
./ \
./checkmout_two/plots 95

checkm tree_qa -o 2 -f treeqaii_out.txt \
./checkmout_two/

checkm nx_plot -x fasta \
./ \
./checkmout_two/plots

checkm marker_plot -x fasta ./checkmout_two/ \
./ \
./checkmout_two/plots

checkm bin_qa_plot -x fasta --image_type svg ./checkm_output2/ fasta/ checkm_output2/plots

checkm merge -x fasta -t 8 checkm_output/lineage.ms fasta/ checkm_output/merger/