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

As a side note, if you have defined the environment variables in your `.bashrc` file like in section 4, then there is no need to specify the account with the `--account` flag. You could simply type `salloc --time=1:00:00 --mem=4G --cpus-per-task=2 --gres=gpu:p100:1`.

If you want to run a notebook, first you have to type those four lines into you terminal (on Cedar) :
```bash
echo -e '#!/bin/bash\nunset XDG_RUNTIME_DIR\njupyter notebook --ip $(hostname -f) --no-browser' > ~/py310.venv/bin/notebook.sh
chmod u+x ~/py310.venv/bin/notebook.sh

echo -e '#!/bin/bash\nunset XDG_RUNTIME_DIR\njupyter lab --ip $(hostname -f) --no-browser' > ~/py310.venv/bin/lab.sh
chmod u+x ~/py310.venv/bin/lab.sh
```
They create scripts (`~/py310.venv/bin/notebook.sh` and `~/py310.venv/bin/lab.sh`) that will start Jupyter notebook and Jupyter lab respectively.

WIP

> # PRACTICE TIME :
> We'll run a basic Jupyter notebook on the cluster. 
First off, type `hostname` into your terminal on Cedar. It should return something like `cedar#.cedar.computecanada.ca`, your current login node. You can also type `nvidia-smi` to verify that you do not yet have any access to a GPU. Now, start an interactive session on Cedar with 2 CPUs, one P100 GPU and 4GB RAM. When your allocation goes through, you should be transferred to a distant node through terminal. If you type `pwd`, you'll notive that you have not moved in the direcory tree ; make no mistake however : by typing `hostname` again you'll see that you are now connected to the node, and `nvidia-smi` should display the specs of the GPU you asked for. 
Then, in the interactive session, start the Jupyter notebook from this git repository.

## 7. `sbatch` allocation and job scripts

The interactive session is most useful for quick debugging. For development, you are probably (should be) working on your lab computer and only pushing to ComputeCanada when you want to massively train your model.

