#!/bin/bash
#SBATCH --account=def-lseoud
#SBATCH --mem=2G
#SBATCH --time=00:01:00

echo "Hello World !"

cd python_scripts
python hello_world.py