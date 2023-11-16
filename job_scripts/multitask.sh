#!/bin/bash
#SBATCH --job-name=parallel_job
#SBATCH --nodes=2
#SBATCH --tasks-per-node=2
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00

#==============================================================================
# This script demonstrates how to run multiple tasks in parallel
# on several nodes using srun
#==============================================================================

echo "Parallel experiment started at $(date)"
cd ~/ComputeCanada_Workshop_VisionIC

# Run the tasks in parallel using srun
srun job_scripts/task.sh
