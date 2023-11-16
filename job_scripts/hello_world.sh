#!/bin/bash
#SBATCH --mem=2G
#SBATCH --time=00:01:00
#SBATCH --job-name=hello_world

echo "Hello World! Script started at $(date)"
cd ~/ComputeCanada_Workshop_VisionIC

# A base version of Python (3.7.7) is already loaded so this will work
python python_scripts/hello_world.py