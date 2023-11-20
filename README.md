# The VisionIC's ComputeCanada Workshop
A hands-on quickstart guide to ComputeCanada (heretoforth abbreviated CC).

# Cheat sheet : some useful SLURM commands

| Command                 | Description                                                                                      |
|-------------------------|--------------------------------------------------------------------------------------------------|
| `salloc`                | Starts an interactive session                                                                    |
| `sbatch <batch script>` | Submits a batch script to run as a job.                                                          |
| `srun <batch command>`  | Runs a batch command in parallel on all available nodes                                          |
| `sq`                    | Displays you current (running and pending) jobs with info                                        |
| `sacct`                 | Displays info about recent jobs                                                                  |
| `seff <job ID>`         | Displays efficiency statistics like percentage of memory used and CPU use for the specified job. |

# Cheat sheet : some useful module commands

| Command                     | Description                                                                                               |
|-----------------------------|-----------------------------------------------------------------------------------------------------------|
| `module purge`              | Unload all supplementary modules. Use flag `--force` to unload even default modules.                      |
| `module list`               | Lists all loaded modules.                                                                                 |
| `module load <module name>` | Load specified module. It is possible to specify the version, e.g. `module load python/3.9.6`             |
| `module spider`             | Displays information about all available modules. Use `module spider <module_name>` to get specific info. |

# The road to glory

## 0. Preliminary step : Create your account

First things first :
- Register for an account at [this adress](https://ccdb.alliancecan.ca/security/login). This is only your account, it won't allow you to use the clusters by itself, because you don't have an *allocation* yet.
- Add a role at [this adress](https://ccdb.alliancecan.ca/me/add_role). This part actually identifies you as a student under Lama's supervision. You'll then be able to access the clusters through the lab's allocation. Note that this is not instantaneous : Lama has to approve your request first, and the team at CC must then process it. This can take a few days. Note that you will need Lama's ComputeCanada identification code (the CCRI).


## 1. SSH Keys [Optional]

Typing your password every time is boring. You could setup an authorized SSH connection by uploading your RSA key to the CC website.
If you are not already familiar with SSH and RSA keys, you can go check a guide or, alternatively, run the few commands below. Understanding is not needed for this part.

Inside a terminal / command prompt, type :
```bash
ssh-keygen -t rsa -b 2048
```
and press enter until it's done. This will create a new RSA key pair in your home directory, in the folder `.ssh`. For the full filepath, check the output of the command you just entered. By default, the key pair is named `id_rsa` and `id_rsa.pub` and it should be located in `C:\Users\<username>/.ssh` on Windows or `~/.ssh` on Linux. The first one is your private key, the second one is your public key. You can now upload your public key to the CC website.

Do **NOT** upload your private key anywhere ! Only the `.pub` file !

Now you can copy all the contents of your new file id_rsa.pub and paste them into the "SSH Key" section on the CC website, at [this adress](https://ccdb.alliancecan.ca/ssh_authorized_keys).

No more password typing !


## 2. Connecting to a cluster

There are two options to get to work on a cluster.

### Option 1 : Using the terminal

This is the most straightforward way to connect to a cluster. It is also useful when you have to quickly edit a single file or are simply willing to submit a job script or check the status of your submitted jobs. According to most people not willing to tap the unholy power of in-terminal IDEs, it is however not the most comfortable way to do more extensive work.

You can connect to a cluster by typing the following command in a terminal :
```bash
ssh <username>@<cluster>.computecanada.ca
```
where `<username>` is your CC username and `<cluster>` is the name of the cluster you want to connect to. For example, if I want to connect to the Cedar cluster, I can type :
```bash
ssh hurodb@cedar.computecanada.ca
```
| Side note : other adress aliases should also work, like `cedar.alliancecan.ca`.

### Option 2 : Using VSCode

This is the most comfortable way to work on a cluster. Other IDEs should have similar remote connection features, but VSCode is the one I'm familiar with. Its RemoteSSH extension allows you to connect to a remote server through SSH and work on it as if it was a local machine. You can then use the integrated terminal, the integrated file explorer, the integrated git, etc.

I will not go into the details here. I've already explained the setup in my guide, available [here on the lab's Teams](https://polymtlca0.sharepoint.com/:b:/s/LamasStudents/ERAdp299ZEROpNn_zzF-7S4B6xghvEvX_c1yoxqzsT9Nvw?e=1Clw4S).


> # PRACTICE TIME : SSH
> Connect to the Cedar cluster using the method of your choice ! Then, clone [this repository](https://github.com/hugorodet-poly/ComputeCanada_Workshop_VisionIC) to your home directory.


## 3. Transferring data

### File storage

There are different storage partitions on CC, each with its own purpose. They are mostly identical across clusters, too.
To check storage, you can use the CC-specific command `diskusage_report`.`
As a reminder from the presentation, here is a quick breakdown of the different directories :

| Designation   | Full path                       | Usage                                                                  | Description                                                                                                                                                                                                                       |
|---------------|---------------------------------|------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| home          | /home/<username>                | Source code, Python venv, App image                                    | Main directory, meant for storing                                                                                                                                                                                                 |
| project       | ~/project/def-lseoud/<username> | Datasets (compressed if possible), job scripts                         | 10TB storage space for the entire lab. To share a file, save it in the `group_writable` directory. Relatively fast filesystem.                                                                                                    |
| nearline      | ~/nearline                      | Inactive data.                                                         | Tape-based storage for archiving unused data. Only for files ranging from 100MB to ~1TB. Do not often write data to this directory.                                                                                               |
| scratch       | ~/scratch                       | Temporary storage, e.g. checkpoints or large datasets during training. | Temporary storage, files older than 60 days are purged (after reminder email). Useful to extract large datasets during job execution as it is a fast filesystem. Do not try to abuse by artificially modifying the age of a file. |
| $SLURM_TMPDIR | $SLURM_TMPDIR                   | Fastest dataset storage, during runtime only                           | Temporary storage created for you on-node during job execution. If your dataset is not too large and is composed of many small files, you should copy its tar file to $SLURM_TMPDIR at job start, then extract.                   |

### Compressing files

Before transferring anything, you should first compress your files. This will save you a lot of bandwidth, and is a good practice overall. Even on ComputeCanada, you should keep your datasets compressed and extract them somewhere before executing your code. The reason is that the different storage directories have a limit in terms of capacity but also in terms of number of files. You can use the `tar` command to compress and decompress files. For example, to compress a folder named `dataset` into a file named `dataset.tar.gz`, you can type :
```bash
tar -czf my_folder.tar.gz my_folder
```
To extract the same compressed dataset, you can type:
```bash
tar -xzf my_folder.tar.gz
```

To remember the arguments, you can think of the following :
- `-czf` = **C**reate **Z**ip **F**ile
- `-xzf` = e**X**tract **Z**ip **F**ile

As a side note, you can also use the `zip` command to compress and decompress files. It is however less efficient than `tar` for large datasets. `zip` only collects a bunch of files into one "compressed folder", while `tar` creates *one file* from all of those (called a tarball, hence the "tar" name) and then compresses it. In the `.tar.gz` extension, the `.tar` represents the one aggregated file, and the `.gz` indicates that it has been compressed with Gzip.

### Transferring files

There are again several options to transfer files to and from the clusters.

#### Option 1 : Using the terminal

You can use the `scp` command to transfer files between your local machine and a cluster. It works just like the `cp` command, except you have to specify the source and destination machines. To copy a file from your local machine to the Cedar cluster, you can open a terminal and type :
```bash
scp <path to source file> <username>@<remote adress>:<path to destination folder>
```

On some clusters like Graham, you should connect to a data transfer node, which is different from the base login adress you would use normally. Instead of `graham.computecanada.ca`, you must use `gra-dtn1.computecanada.ca`. On Cedar there is no such login/transfer difference, as far as I know.

For example, if I want to send a compressed dataset to my project space, I can go to the folder where my `dataset.tar.gz` file is held, right-click somewhere empty, choose "Open in terminal" and type :
```bash
scp dataset.tar.gz hurodb@cedar.computecanada.ca:~/projects/def-lseoud/hurodb
```

#### Option 2 : Using Globus

Globus is a service provider for data management, geared towards research. It allows you to transfer files between different endpoints, including ComputeCanada clusters. It is a very useful tool, especially when you have to transfer large datasets. It is also very easy to use.

However, I don't like signing in to three different platforms and learning a new tool when I can achieve the same result with one simple command line. As such, I don't really know how to use Globus : I have confirmed that it works but I've gone no further. I'll let you figure it out on your own. [Here's the link to the Globus website](https://www.globus.org/).

> # PRACTICE TIME : DATA TRANSFER
> Download the MNIST dataset on your local machine from [this adress](https://drive.google.com/file/d/1MdnPwwPhGRxHV0d2N-lT1Q6041loSyAI/view?usp=sharing) (it's only 22MB). It's also a zip file, not a tar file, so to get used to `tar` I'd advise you first extract the contents using the method of your choice. Then, connect to CC through a terminal and transfer the tar file to your project space on Cedar using `scp`. We won't use this dataset for the rest of the workshop, but it's a good practice nonetheless.


## 4. `.bashrc` file

Another thing to setup before we start. If you've ever really worked on a Linux machine, then surely you know about the `.bashrc` file. It is a file that is executed every time you open a terminal. It is used to set up your environment, for example by adding aliases or defining environment variables. It works the same way on CC clusters.

The `.bashrc` file is located in your home directory, and is hidden by default. To edit it, you can use the `nano` command. For example, to edit the `.bashrc` file on Cedar with `nano`, you can type :
```bash
nano ~/.bashrc
```

You can then add the following lines to the file :
```bash
export SLURM_ACCOUNT=def-lseoud
export SBATCH_ACCOUNT=$SLURM_ACCOUNT
export SALLOC_ACCOUNT=$SLURM_ACCOUNT
```
This tells SLURM that every time you submit any job, you do so under the lab's resource allocation.

Now, after trying to check outputs a few times (we'll get to that later), you will probably grow tired of having to find the exact job number and copy/pasting (or even typing) it to display the contents of the file. In my own `.bashrc`, I have defined two aliases. `olerr` stands for "**o**pen **l**ast **err**or file" and `olout` stands for -you guessed it- "**o**pen **l**ast **out**put file".
```bash
alias olerr='cat `ls -Art | grep .error | tail -n 1`'
alias olout='cat `ls -Art | grep .out | tail -n 1`'
```


Another thing you should add to your `.bashrc` file is the Weights&Biases API key, which allows you to log in and upload your metrics at runtime. You'll find it [here in the user settings](https://wandb.ai/settings). You can add it to your `.bashrc` file like so :
```bash
export API_KEY=<your API key>
```

That's it for the most part, but don't hesitate to define as many aliases and evironment variables as you want/need.


## 5. Python Setup

Before we try to run any code, we'll need to create a Python virtual environment, preferably in your home directory. As reminder, we need to do this because the processing nodes are literally different computers with distinct systems, and you can't just install the packages on every single one of them. 


By default, only some older version of Python is loaded. To load the version you want (e.g. 3.9.6), you can type :
```bash
module load python/3.9.6
```
It could as well have been another version. With Python loaded, you also gain access to the `virtualenv` package.
You can create a virtual environment named `workshop.venv` by typing :
```bash
virtualenv workshop.venv
```
As a side note, `virtualenv` is defined on Cedar as an alias to `python -m virtualenv`.

To activate the virtual environment, type :
```bash
source workshop.venv/bin/activate
```
You can exit by typing `deactivate`.
You can then install the packages used in this tutorial.

Some packages exist in local repositories, like PyTorch. They are actually custom versions of those packages, optimized for the CC software architecture. While they are available as usual through the PyPI online repository, if possible it is recommended that you install the custom versions whenever possible. Some packages might even work only if you installed the custom version.

Usually, when you install a package through `pip install`, it will first look for the package in the local repository. If it doesn't find it, it will then look for it in the PyPI repository. If you want to make sure to install the custom version, you can force `pip` to only look in the local repository by using the `--no-index` flag.

For example, to install PyTorch, you can type :
```bash
pip install --no-index torch torchvision
```

Additionally, some packages like OpenCValready exist in the form of modules. In that case, it is recommended you activate the module **instead** of installing the package the usual way. Activate the module *before* loading up a virtual environment. In OpenCV's case, you *should not* install the Python package through `pip`, lest you get an error. You can load the module using the `module load` command. For example, to load OpenCV, you can type :
```bash
module load opencv
```

I repeat, do not pip install OpenCV in your virtual environment :)

> # PRACTICE TIME : VIRTUALENV
> Create a Python virtual environment in your home directory named `workshop.venv`, activate it and install the following packages, either by hand or by using the `requirements.txt` file. The packages are :  `torch==1.13.1`, `torchvision==0.14.1`


## 6. Interactive Session

The first thing you should do is start an interactive session. This will allow you to work on the cluster as if it was your own machine, with the added benefit of having access to the cluster's resources. To start an interactive session, you can use the `salloc` command. For example, to start an one-hour interactive session on Cedar with one P100 GPU, 2 CPUs and 4GB RAM, you can type :
```bash
salloc --account=def-lseoud --time=1:00:00 --mem=4G --cpus-per-task=2 --gres=gpu:p100:1
```
In order the lessen the load on the filesystem, on Cedar you cannot use this command directly from you home directory. Instead, you must `cd` to your project directory first (at `~/projects/def-lseoud/<username>` and execute from there).

As a side note, if you have defined the environment variables in your `.bashrc` file like in section 4, then there is no need to specify the account with the `--account` flag. You could simply type `salloc --time=1:00:00 --mem=4G --cpus-per-task=2 --gres=gpu:p100:1`.

If you want to run a notebook, no. Well, actually, yes, but it's not that easy. If for some reason you absolutely want to use notebooks on ComputeCanada, check [this excellent guide](https://prashp.gitlab.io/post/compute-canada-tut/).

Interactive sessions connect your *terminal* to the remote node. Thus, anything you'll execute using your terminal will run on the remote processing node. Note that this does not apply to your entire VSCode session, only to the terminal used to run `salloc`. Remember : VSCode is installed on your local machine and the RemoteSSH extension connects to the login node on Cedar (e.g. cedar1) to work there remotely. If you start an interactive session through a terminal opened with VSCode, only the terminal will be transferred. VSCode will remain connected to the login node.

> # PRACTICE TIME : INTERACTIVE SESSIONS
> First off, type `hostname` into your terminal on Cedar. It should return something like `cedar#.cedar.computecanada.ca`, your current login node. You can also type `nvidia-smi` to verify that you do not yet have any access to a GPU. Now, start an interactive session on Cedar with 2 CPUs, one P100 GPU and 4GB RAM. 
>
>When your allocation goes through, you should be transferred to a distant node through terminal. If you type `pwd`, you'll notice that you have not moved in the directory tree ; make no mistake however : by typing `hostname` again you'll see that you are now connected to the node, and `nvidia-smi` should display the specs of the GPU you asked for. Also, if you had loaded a module or activated a virtual environment, they are now deativated since you are not on the same machine anymore. If you want, you can execute the Pythin script `hello_world.py`.

## 7. `sbatch` allocation and job scripts

The interactive session is most useful for quick debugging. For development, you are probably (should be) working on your lab computer and only pushing to ComputeCanada when you want to massively train your model.

Contrary to `salloc` which lets you do things freely after allocation, `sbatch` submits a batch script (you know, the `.sh` files)

Much like `salloc` previously described however, you have to specify the necessary resources for your job. Since you have better things to do than type all the arguments every time you `sbatch`, you can instead specify them directly at the top of the batch script. SLURM reads it automatically. Thus, your script should look like this :
```bash
#!/bin/bash
#SBATCH --mem=2G
#SBATCH --time=00:01:00
```	

As a side note for those unfamiliar with batch scripts, `#!/bin/bash` is a line present in almost every executable script. It tells the OS that the file should be executed using the bash interpreter (i.e. the usual command prompt), thus giving you access to everything you've defined in the `.bashrc` file. The other lines starting with #SBATCH are called SLURM directives.

SLURM directives actually have other uses than resource allocation. You can also specify the name of the job, the output and error files, the email adress to send notifications to, etc. 

Output and error filenames can be specified using placeholders like %x (job name), %A (job ID), %a (array ID) and %j (job allocation ID). When writing the path for the ouput and error files, be careful to write the full path starting with `/home/<username>` instead of `~` : those lines are executed through SLURM and not through your session !

Some examples :
```bash
#SBATCH --job-name=<job name>
#SBATCH --mail-user=<mail>
#SBATCH --mail-type=ALL
#SBATCH --output=/home/<username>/outputs/R-%x-%A-%a-%j.out
#SBATCH --error=/home/<username>/outputs/R-%x-%A-%a-%j.error
```

Note that the output files contain the standard output ("stdout") of the job, while the error files contain the standard error ("stderr"). By default, they are not separated and the single `.out` file ends up in the directory you submitted the job from.

Just like for `salloc`, you can't run `sbatch` from you home directory. Either copy the script files to your project directory (recommended) or `cd` to it first then write the full path, e.g. `sbatch ~/ComputeCanada_Workshop_Visionic/job_scripts/example1.sh`.

When you wait for the job to be allocated / finish, you can type `sq`. It will list some resources specified like CPUs or time left, as well as the job ID and name. To cancel a job, you can type `scancel <job ID>`. You can also cancel all pending jobs using `scancel -u $USER -t PENDING`.

> # PRACTICE TIME : HELLO WORLD
> Submit the simple `hello_world.sh` script. If you are bored, you can create an `outputs` folder in your home directory to store the... well, outputs and add the directives above. You'll have to add them to every script OR export them through your `.bashrc` if you want future outputs to end up here too. Type `sq` to check advancement.


## 8. Job arrays

If you want to submit several experiments differing only by some parameters (for instance if you are doing hyperparameter search), there are several ways to go about it. You could write a script that takes arguments and submits it several times, or you could use a job array. The latter is the most efficient way to do it, because it helps SLURM compute the needed resources more efficiently, and is the overall recommended way. We'll cover it in this section.

As a side note, Weights&Biases also implements a way to deal with hyperparameter search if that is really what you're after. I won't cover it in this guide because it would need a guide of its own (one day, maybe), but it's rather efficient.

To submit a job array, you have to specify the number of jobs in the array with the `--array` flag/directive. You can then access the array ID at runtime with the `$SLURM_ARRAY_TASK_ID` environment variable.

If you type `sq`, you'll see what jobs from the array have been allocated resources and which ones are still pending.

To change parameters between one job to another inside the array, there are once again several ways to go about it. In both cases I am assuming that you hold the config of you experiment in a YAML file. If you're not already something like this (YAML or JSON or another Python file, regardless), you should consider it.

### Option 1 : Multiple job configs

If you have a lot of parameters to change it might be easier to simply use several files. Index them with an integer and call them separately using the `$SLURM_ARRAY_TASK_ID` environment variable.

### Option 2 : One job config, and the `sed` command

`sed` is a *very* powerful tool for Linux users. Amongst numerous other things, it allows you to search and replace in a file. For instance, if my YAML config file has a parameter `seed: N` where N is any number, I can replace it with the array ID by typing :
```bash
sed -i "s/seed: .*/seed: $SLURM_ARRAY_TASK_ID/g" config.yaml
```

If you'd like to know more about the `sed` command, you can check [this page](https://www.cyberciti.biz/faq/how-to-use-sed-to-find-and-replace-text-in-files-in-linux-unix-shell/).

> # PRACTICE TIME : ARRAYS
> The scripts `array.sh` and `array_sed.sh` each implement one of those two options. Open them, read them, and submit them as jobs. Check the outputs.


## 9. Multiple CPUs

On the same node, you might want to use several CPUs, for instance to parallelize data loading using several workers. You can ask for several CPUs using the `--cpus-per-task` flag/directive.

> # PRACTICE TIME :
> Start an interactive session with 4 CPUs and 4GB RAM, for about 10 minutes. Read and run the python script `multiprocess.py`. When this is done, you can run the same script but with an interactive session holding only 2 CPUs. You should see that the time elapsed is roughly the same when using 4 processes and 2 processes, since you can't use more cores than allocated.


## 10. Multiple nodes, multiple tasks, and `srun`

If you'd like to run parallel code on several nodes insted of just doing multi-processing, you can use the `srun` command. If you use it inside a job script, it will use the nodes and resources allocated by `sbatch`. If you use it inside an interactive session, it will use the resources allocated by `salloc`. If you use it outside of those, it will allocate the resources on the fly.

When you ask for several nodes, upon allocation you will be transferred to the first of those node (during an interactive session), or the job script will be copied and executed on the first of those nodes (after a batch script submission). You can then use `srun` to execute your code on the other nodes. Even when the code is executed in another node, any terminal output will still be transferred to your current terminal on the first node. 

You can specify the number of nodes and tasks per node using the `--nodes` and `--ntasks-per-node` flags/directives. Alternatively, you can use the `--ntasks` flag/directive to specify the total number of tasks and let SLURM figure out how many nodes to allocate.

And you can display in parallel the host name of every node you're connected to by typing :
```bash
srun hostname
```

Instead of a single-line command like `hostname`, you can also run a batch script (technically, running a script *is* a command). For example, you can run the Python script `task.sh` by simply typing :
```bash
srun task.sh
```
Beware however that the first line of said script `task.sh` must be `#!/bin/bash` for this to work. Else you'll get an error.


As a side note, it is possible to run commands in parallel on only certain designated nodes, if necessary.


> # PRACTICE TIME : MULTITASK
> Read and submit the batch script `multitasking.sh`. Check the output : you should see that the runs were running in parallel. Alternatively, you can just start an interactive session with the same resources requirements and run the Python script `task.sh` "by hand" using `srun`. 


## 11. Multiple GPUs


This is where we put together a full deep learning pipeline. So far we have conveniently ignored module (and the virtual environment we have created in section 5), because the scripts were very simple and used old libraries that already existed in the Python 3.7.7, which is the default version loaded on Cedar.

> # PRACTICE TIME : MULTITASK
> Read and submit the batch script `multigpu.sh`. Check the ouput : it should indicate running on 4 GPUs.


## 12. Fluffed-out example script

`example.sh` is a fluffed-out example script, with all the bells and whistles. It is a script I used for a project, and it is meant to be run on the Cedar cluster. It is a bit more complex than what we've seen so far, but it is a good example of what you can do with SLURM.
