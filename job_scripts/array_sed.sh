#!/bin/bash
#SBATCH --mem=2G
#SBATCH --time=00:01:00
#SBATCH --job-name=array_sed
#SBATCH --array=1-3

#==============================================================================
# This script demonstrates how to use sed to modify a config file
#==============================================================================

echo "Array experiment $SLURM_ARRAY_TASK_ID started at $(date)"
cd ~/ComputeCanada_Workshop_VisionIC

# Here we have only one config file
# But we'll modify it using the sed command and the array index
sed -i "s/seed: .*/seed: $SLURM_ARRAY_TASK_ID/g" configs/config.yaml

python python_scripts/array.py configs/config.yml