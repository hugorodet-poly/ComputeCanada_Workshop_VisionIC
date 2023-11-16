#!/bin/bash
#SBATCH --mem=2G
#SBATCH --time=00:01:00
#SBATCH --job-name=example1
#SBATCH --output=/home/hurodb/outputs/R-%x-%A-%a-%j.out
#SBATCH --error=/home/hurodb/outputs/R-%x-%A-%a-%j.error
#SBATCH --array=1-3

echo "Array experiment $SLURM_ARRAY_TASK_ID started at $(date)"

# As an argument we pass one of the many config files
# It is specified using the array index
cd python_scripts
python array.py ../configs/config$SLURM_ARRAY_TASK_ID.yml