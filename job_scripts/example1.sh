#!/bin/bash
#SBATCH --mem=2G
#SBATCH --time=00:01:00
#SBATCH --job-name=example1
#SBATCH --output=/home/hurodb/outputs/R-%x-%A-%a-%j.out
#SBATCH --error=/home/hurodb/outputs/R-%x-%A-%a-%j.error

echo "Hello World! Script started at $(date)"

cd python_scripts
python hello_world.py