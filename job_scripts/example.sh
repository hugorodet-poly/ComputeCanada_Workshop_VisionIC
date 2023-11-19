#!/bin/bash
#SBATCH --account=def-lseoud
#SBATCH --job-name=example
#SBATCH --mem=32G
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gpus-per-node=v100l:1
#SBATCH --time=16:0:0    
#SBATCH --mail-user=hugo.rodet@polymtl.ca
#SBATCH --mail-type=ALL
#SBATCH --output=/home/hurodb/outputs/R-%x-%A-%a-%j.out
#SBATCH --error=/home/hurodb/outputs/R-%x-%A-%a-%j.error
#SBATCH --array=1-10

# Note : for the output files, use /home/<username> instead of ~

echo "=== Script began at $(date)"

#==============================================================================
# Set the main variable here. The rest should usually be left untouched.

SRC_PROJECT_ROOT=/home/hurodb/infant_pose_estimation/custom_shape_templates
DST_PROJECT_ROOT=$SLURM_TMPDIR/custom_shape_templates
CFG_FILENAME=train.yaml
DATASET_DIRNAME=Human36M_crop0_fixed

#==============================================================================

# Some more advanced variable definitions.
ENV_DIRPATH=~/py39.venv
CHECKPOINTS_DIRPATH=~/checkpoints
DATASET_SRC_TARPATH=/project/def-lseoud/hurodb/datasets/$DATASET_DIRNAME.tar.gz
DATASET_DST_TARPATH=$SLURM_TMPDIR/$DATASET_DIRNAME.tar.gz
DATASET_DST_DIRPATH=$SLURM_TMPDIR/$DATASET_DIRNAME
CFG_FILEPATH=$DST_PROJECT_ROOT/configs/$CFG_FILENAME
WANDB_CFG_FILEPATH=$DST_PROJECT_ROOT/configs/wandb.yaml

# Copy the useful part of the project to node
# The rest of the git repository is not needed for training
echo "=== Copying project files to node"
cp -r $SRC_PROJECT_ROOT $DST_PROJECT_ROOT

# Modify the config file with the updated dataset paths
# This is because I want to be able to push/pull and run the code directly
# without having to modify the paths by hand every time OR have a separated config
# file with the cedar paths, since the config file changes often
# I use sed to search and replace in the config file
echo "=== Modifying project config"
sed -i "s,checkpoint_dir: .*,checkpoint_dir: $CHECKPOINTS_DIRPATH,g" $CFG_FILEPATH
sed -i "s,dataset_path: .*,dataset_path: $DATASET_DST_DIRPATH,g" $CFG_FILEPATH

# If the job is an array, modify the seed in the config file
# This is the only thing that varies between jobs in the array
# If there were more things to modify than a simple numeric value,
# I would probably resort to several different config files
if [[ ! -z ${SLURM_ARRAY_TASK_ID+z} ]] # If the variable is not empty (i.e. job is an array) :
then
    echo "Running within a job array with ID $SLURM_ARRAY_TASK_ID"
    sed -i "s,seed: .*,seed: $SLURM_ARRAY_TASK_ID,g" $CFG_FILEPATH
fi

# Extract the dataset in SLURM_TMPDIR for fast data access
# If the dataset is too heavy, I'd advise using scratch instead
echo "=== Extracting the dataset"
cp $DATASET_SRC_TARPATH $DATASET_DST_TARPATH
tar -xzf $DATASET_DST_TARPATH -C $SLURM_TMPDIR/

# Setup modules related to Python install
# Do this before loading the virtual environment
echo "=== Loading Python and modules"
module purge
module load python/3.9.6 scipy-stack
module load gcc/9.3.0
module load opencv/4.7.0

# Activate the virtual environment, self-explicit here
echo "=== Activating virtual environment"
source $ENV_DIRPATH/bin/activate

# Mandatory login to WandB.
# My API key is stored and exported in my .bashrc file 
echo "=== Logging in to WandB"
wandb login $API_KEY

# Training
echo "=== Running python experiment"
cd $DST_PROJECT_ROOT
python unsupervised_train.py --config $CFG_FILEPATH --wandb $WANDB_CFG_FILEPATH

echo '=== End of script'
date