
ccs --numThreads 16 \
--minPasses=1 \
--minPredictedAccuracy=0.8 \
--minLength 100 \
--maxLength 20000 \
--polish \
--reportFile "ccs_report.txt" \
all_smrtcell1.subreads.bam \
ccs/all_smrtcell1_ccs.subreads.bam
