# The VisionIC's ComputeCanada Workshop
A hands-on quickstart guide to ComputeCanada (heretoforth abbreviated CC).


## 0. Preliminary step : Create your account

First things first :
- Register for an account at [this adress](https://ccdb.alliancecan.ca/security/login). This is only your account, it won't allow you to use the clusters by itself.
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


> # PRACTICE TIME :
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

Before you transfer anything, you should compress your files. This will save you a lot of bandwidth, and is a good practice overall. Even on ComputeCanada, you should keep your datasets compressed and extract them somewhere before executing your code, the reason being that the different storage directories have a limit in terms of capacity but also in terms of number of files. You can use the `tar` command to compress and decompress files. For example, to compress a folder named `dataset` into a file named `dataset.tar.gz`, you can type :
```bash
tar -czf my_folder.tar.gz my_folder
```
To extract the same compressed dataset, you can type:
```bash
tar -xzf my_folder.tar.gz
```

To remember the arguments for creation and extraction, you can think of the following :
- `-czf` = **C**reate **Z**ip **F**ile
- `-xzf` = e**X**tract **Z**ip **F**ile

As a side note, you can also use the `zip` command to compress and decompress files. It is however less efficient than `tar` for large datasets. `zip` collects a bunch of files into one "compressed folder", while `tar` creates *one file* from all of those (called a tarball, hence the "tar" name) and then compresses it. In the `.tar.gz` extension, the `.tar` represents the one aggregated file, and the `.gz` indicates that it has been compressed.

### Transferring files

There are again several options to transfer files to and from the clusters.

#### Option 1 : Using the terminal

You can use the `scp` command to transfer files between your local machine and a cluster. It works just like the `cp` command, except you have to specify the source and destination machines. To copy a file from your local machine to the Cedar cluster, you can open a terminal and type :
```bash
scp <path to file> <username>@<remote adress>:<path to destination>
```

On some clusters like Graham, you should connect to a data transfer node, which is different from the base login adress you would use normally. Instead of `graham.computecanada.ca`, you must use `gra-dtn1.computecanada.ca`. On Cedar there is no such difference.

For example, if I want to send a compressed dataset to my project space, I can go to the folder where my `dataset.tar.gz` file is held, right-click somewhere empty, choose "Open in terminal" and type :
```bash
scp dataset.tar.gz hurodb@cedar.computecanada.ca:~/projects/def-lseoud/hurodb
```

#### Option 2 : Using Globus

Globus is a service provider for data management, geared towards research. It allows you to transfer files between different endpoints, including ComputeCanada clusters. It is a very useful tool, especially when you have to transfer large datasets. It is also very easy to use.

However, I don't like signing in to three different platforms and learning a new tool when I can do what I need to with one measly command line. As such I don't really know how to use Globus, I have confirmed that it works but I've gone no further. I'll let you figure it out on your own. [Here's the link to the Globus website](https://www.globus.org/).

> # PRACTICE TIME :
> Download the MNIST dataset on your local machine from [this adress](https://drive.google.com/file/d/1MdnPwwPhGRxHV0d2N-lT1Q6041loSyAI/view?usp=sharing) (it's only 22MB). It's also a zip file, not a tar file, so to get used to `tar` I'd advise you first extract the contents using the method of your choice. Then, connect to CC through a terminal and transfer the tar file to your project space on Cedar using `scp`.


## 4. `.bashrc` file

One last setup before we start. If you've ever really worked on a Linux machine, then surely you know about the `.bashrc` file. It is a file that is executed every time you open a terminal. It is used to set up your environment, for example by adding aliases or setting environment variables. You can also use it to set up your environment on the CC clusters.

The `.bashrc` file is located in your home directory, and is hidden by default. To edit it, you can use the `nano` command. For example, to edit the `.bashrc` file on Cedar, you can type :
```bash
nano ~/.bashrc
```

You can then add the following lines to the file :
```bash
export SLURM_ACCOUNT=def-lseoud
export SBATCH_ACCOUNT=$SLURM_ACCOUNT
export SALLOC_ACCOUNT=$SLURM_ACCOUNT
```
This tells SLURM that every time you subit a job, you do so under the lab's resource allocation.

Don't hesitate to define as many aliases and evironment variables as you want/need. We'll cover some more of them in latter sections.


## Python Setup

Before we try to run any code, we'll need to create a Python virtual environment, preferably in your home directory.
By default, Python is not "installed" (i.e. loaded; remember that several versions are installed but to gain access to them you have to load the corresponding module). You can check this by typing `python` in a terminal. You should get an error message saying that the command is not found. To load Python, you can type :
```bash
module load python/3.10.2
```
It could as well have been another version. With Python loaded, you also gain access to the `virtualenv` package.
You can create a virtual environment named `py310.venv` by typing :
```bash
virtualenv py310.venv
```

To activate the virtual environment, type :
```bash
source py310.venv/bin/activate
```
Exit by typing `deactivate`.
You can then install the packages used in this tutorial.

> # PRACTICE TIME :
> Create a Python virtual environment named `py310.venv`, activate it and install the packages used in this tutorial, either by hand or by using the `requirements.txt` file.


## 6. Interactive Session

The first thing you should do is start an interactive session. This will allow you to work on the cluster as if it was your own machine, with the added benefit of having access to the cluster's resources. To start an interactive session, you can use the `salloc` command. For example, to start an one-hour interactive session on Cedar with one P100 GPU, 2 CPUs and 4GB RAM, you can type :
```bash
salloc --account=def-lseoud --time=1:00:00 --mem=4G --cpus-per-task=2 --gres=gpu:p100:1
```
In order the lessen the load on the filesystem, on Cedar you cannot use this command directly fomr you home directory. Instead, you must `cd` to your project directory first (at `~/projects/def-lseoud/<username>` and execute from there).

As a side note, if you have defined the environment variables in your `.bashrc` file like in section 4, then there is no need to specify the account with the `--account` flag. You could simply type `salloc --time=1:00:00 --mem=4G --cpus-per-task=2 --gres=gpu:p100:1`.

If you want to run a notebook, no. Well, actually, yes, but it's not that easy. If for some reason you absolutely want to use notebooks on ComputeCanada, check [this excellent guide](https://prashp.gitlab.io/post/compute-canada-tut/).

Interactive sessions connect your *terminal* to the remote node. Thus, anything you'll execute using your terminal will run on the remote processing node. This does not apply to VSCode. Remember : VSCode is installed on your local machine and the RemoteSSH extension connects to the login node on Cedar (e.g. cedar1) to work there remotely. If you start an interactive session through a terminal opened with VSCode, only the terminal will be transferred. VSCode will remain connected to the login node.

> # PRACTICE TIME :
> First off, type `hostname` into your terminal on Cedar. It should return something like `cedar#.cedar.computecanada.ca`, your current login node. You can also type `nvidia-smi` to verify that you do not yet have any access to a GPU. Now, start an interactive session on Cedar with 2 CPUs, one P100 GPU and 4GB RAM. 
>
>When your allocation goes through, you should be transferred to a distant node through terminal. If you type `pwd`, you'll notive that you have not moved in the direcory tree ; make no mistake however : by typing `hostname` again you'll see that you are now connected to the node, and `nvidia-smi` should display the specs of the GPU you asked for. Also, if you had loaded a module or activated a virtual environment, they are deativated now since you are not on the same machine anymore.
Then, in the interactive session, start the Jupyter notebook from this git repository.

## 7. `sbatch` allocation and job scripts

The interactive session is most useful for quick debugging. For development, you are probably (should be) working on your lab computer and only pushing to ComputeCanada when you want to massively train your model.

Much like `salloc` previously described, you have to specify the necessary resources for your job. Since you have better things to do than write all the arguments every time, you can simply write them at the top of the batch script. SLURM reads it automatically. Thus, your script should look like this :
```bash
#!/bin/bash
#SBATCH --mem=2G
#SBATCH --time=00:01:00
```	

As a side note for those unfamiliar with batch scripts, #!/bin/bash is a line present in almost every executabe script indicating to the system that the file should be executed in the terminal using the bash interpreter, giving you access to everything you've defined in the `.bashrc` file. 

The other lines starting with #SBATCH are SLURM directives, telling the system how to run the job. The ones you don't specify get default values.

SLURM directives are actually not only for resource allocation. You can also specify the name of the job, the output and error files, the email adress to send notifications to, etc. 

Output and error filenames can be specified using placeholders like %x (job name), %A (job ID), %a (array ID) and %j (job allocation ID). When writing their paths, be careful to write the full path starting with `/home/<username>` instead of `~`, because those are executed through SLURM and not through your session !

Some examples :
```bash
#SBATCH --job-name=<job name>
#SBATCH --mail-user=<mail>
#SBATCH --mail-type=ALL
#SBATCH --output=/home/<username>/outputs/R-%x-%A-%a-%j.out
#SBATCH --error=/home/<username>/outputs/R-%x-%A-%a-%j.error
```

Note that the output files contain the standard output ("stdout") of the job, while the error files contain the standard error ("stderr"). By default, they are not separated and the single file ends up in the directory from where you submitted the job.

Just like for `salloc`, you can't run sbatch from you home directory. Either copy the script files to your project directory (recommended) or `cd` to it first then write the full path, e.g. `sbatch ~/ComputeCanada_Workshop_Visionic/job_scripts/example1.sh`.

When you wait for the job to be allocated / finish, you can type `sq`. It will list some resources specified like CPUs or time left, as well as the job ID and name. You can then type `squeue -j <job ID>` to get more information about the job, like the output and error files.

> # PRACTICE TIME :
> Submit the simple `hello_world.sh` script. You can create an `outputs` folder in your home directory to store the... well, outputs and add the directives above if you want to. Type `sq` to check advancement.


## 8. Job arrays

If you want to submit several experiments differing only by some parameters (for instance if you are doing hyperparameter search), there are several ways to go about it. You could write a script that takes arguments and submit it several times, or you could use a job array. The latter is the most efficient way to do it, because it helps SLURM compute the needed resources more efficiently, and is the recommended way.

As a side note, Waeights&Biases also implements a way to deal with hyperparameter search if taht is really what you're after. I won't cover it in this guide because it would need a guide of its own (one day, maybe).

To submit a job array, you have to specify the number of jobs in the array with the `--array` flag/directive. You can then access the array ID at runtime with the `$SLURM_ARRAY_TASK_ID` environment variable.

If you type `sq`, you'll see what jobs have been allocated resources and which ones are still pending.

To change parameters between one job to another inside the array, there are once again several ways to go about it. In both cases I am assuming that you hold the config of you experiment in a YAML file. If you're not already something like this (YAML or JSON or another Python file, regardless), you should consider it.

### Option 1 : Multiple job configs

If you have a lot of parameters to change it might be easier to simply use several files. Index them with an integer and call them separately using the `$SLURM_ARRAY_TASK_ID` environment variable.

### Option 2 : One job config, and the `sed` command

`sed` is a *very* powerful tool for Linux users. Amongst numerous other things, it allows you to search and replace in a file. For instance, if my YAML config file has a parameter `seed: N` where N is an integer, I can replace it with the array ID by typing :
```bash
sed -i "s/seed: .*/seed: $SLURM_ARRAY_TASK_ID/g" config.yaml
```

If you'd like to know more about the `sed` command, you can check [this page](https://www.cyberciti.biz/faq/how-to-use-sed-to-find-and-replace-text-in-files-in-linux-unix-shell/).

> # PRACTICE TIME :
> The scripts `array.sh` and `array_sed.sh` each implement one of those two options. Open them, read them, and submit them as jobs. You can check the outputs in the `outputs` folder you've created previously.


## 9. Multiple CPUs

On the same node, you might want to use several CPUs, for instance to parallelize data loading using several workers.




## 10. Multiple nodes, multiple tasks, and `srun`

If you'd like to run parallel code on several nodes insted of just doing multi-processing, you can use the `srun` command. If you use it inside a job script, it will the nodes and resources allocated by `sbatch`. If you use it inside an interactive session, it will use the resources allocated by `salloc`. If you use it outside of those, it will allocate the resources on the fly.

When you ask for several nodes, upon allocation you will be transferred to the first of those node (during an interactive session), or the job script will be copied and executed on the first of those nodes (after a batch script submission). You can then use `srun` to execute your code on the other nodes. Even when the code is executed in another node, any terminal output will still be transferred to your current terminal on the first node. 

For instance, if you want to run a script on 4 nodes with 1 CPU and 4GB RAM each, the directives are :
```bash
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
```

And you can display in parallel the host name of every node you're connected to by typing :
```bash
srun hostname
```

As a side note, it is possible to run commands in rapallel on only certain designated nodes, if necessary.


> # PRACTICE TIME :
> Read the script `multitasking.sh`, submit it and check the output. You should see that the runs were indeed parallel. Start an interactive session with 4 nodes and 2 tasks per node and run `hostname` in parallel to verify that you have 4 different hosts with exactly 2 tasks each. You can also play arounf with the parallel capbilities.


## 11. Multiple GPUs

Last but not least, you might be interested in learning how to use several GPUs at once ! Of course, they all have to be on the same node. If they weren't, it would be called federated learning and that's someone else's problem.

