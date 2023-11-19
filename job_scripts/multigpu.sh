#!/bin/bash
#SBATCH --job-name=gpu_job
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=10
#SBATCH --gres=gpu:4
#SBATCH --time=24:00:00
#SBATCH --mem=64G

# Load the required modules before activating the virtual environment
module load python/3.9.6 scipy-stack

# Activate the virtual environment
source ~/workshop.venv/bin/activate

# Run your neural network training script
cd ~/ComputeCanada_Workshop_VisionIC/python_scripts
python multigpu.py
