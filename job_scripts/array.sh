#!/bin/bash
#SBATCH --mem=2G
#SBATCH --time=00:01:00
#SBATCH --job-name=array
#SBATCH --array=1-3

#==============================================================================
# This cript demonstrates how to use $SLURM_ARRAY_TASK_ID
# To specify different files for each array task
#==============================================================================

echo "Array experiment $SLURM_ARRAY_TASK_ID started at $(date)"
cd ~/ComputeCanada_Workshop_VisionIC

# As an argument we pass one of the many config files
# It is specified using the array index
python python_scripts/array.py configs/config$SLURM_ARRAY_TASK_ID.yml