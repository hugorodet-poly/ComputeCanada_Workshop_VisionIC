#!/bin/bash
#SBATCH --job-name=gpu_job
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=10
#SBATCH --gres=gpu:4
#SBATCH --time=24:00:00
#SBATCH --mem=64G

# Load the required modules
module load cuda cudnn

# Run your neural network training script
python train.py
