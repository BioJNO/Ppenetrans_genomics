#!/bin/sh
# Tell the SGE that this is an array job, with "tasks" to be numbered 1-23
#$ -t 1-23 

i=$(expr $SGE_TASK_ID)

LD_LIBRARY_PATH="/mnt/shared/scratch/synology/jo42324/apps/gccopencl/opt/amd-opencl-icd-15.302/lib:$LD_LIBRARY_PATH"
export OPENCL_INC=/mnt/shared/scratch/synology/jo42324/apps/gccopencl/opt/opencl-headers/include/CL
export OPENCL_VENDOR_PATH=/mnt/shared/scratch/synology/jo42324/apps/openclvendors
wait 

pacasus.py \
--device_type=CPU \
--platform_name=AMD \
--framework=OpenCL \
-o pacasus-out-$i.fasta \
--loglevel=INFO \
-1 fasta group_$i.fasta
