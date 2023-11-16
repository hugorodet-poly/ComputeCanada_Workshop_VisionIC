#!/bin/bash
#SBATCH --job-name=parallel_job
#SBATCH --nodes=2
#SBATCH --tasks-per-node=2
#SBATCH --cpus-per-task=1

#==============================================================================
# This script demonstrates how to run multiple tasks in parallel
# on several nodes using srun
#==============================================================================

# Define the number of tasks to run
num_tasks=8

# Run the tasks in parallel using srun
srun -n $num_tasks `hostname && sleep 10 && echo "Done!"`
