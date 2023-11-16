#!/bin/bash
#SBATCH --mem=2G
#SBATCH --time=00:01:00
#SBATCH --job-name=example1
#SBATCH --output=/home/hurodb/outputs/R-%x-%A-%a-%j.out
#SBATCH --error=/home/hurodb/outputs/R-%x-%A-%a-%j.error
#SBATCH --array=1-3

echo "Array experiment $SLURM_ARRAY_TASK_ID started at $(date)"

# Here we have only one config file
# But we'll modify it using the sed command and the array index
sed -i "s/seed: .*/seed: $SLURM_ARRAY_TASK_ID/g" config.yaml

cd python_scripts
python array.py ../configs/config.yml