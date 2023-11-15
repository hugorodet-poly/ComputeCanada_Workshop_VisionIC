# The VisionIC's ComputeCanada Workshop
A hands-on quickstart guide to ComputeCanada (heretoforth abbreviated CC).


## 0. Preliminary step : Create your account

First things first :
- Register for an account at [this adress](https://ccdb.alliancecan.ca/security/login). This is only your account, it won't allow you to use the clusters by itself.
- Add a role at [this adress](https://ccdb.alliancecan.ca/me/add_role). This part actually identifies you as a student under Lama's supervision. You'll then be able to access the clusters through the lab's allocation. Note that this is not instantaneous : Lama has to approve your request first, and the team at CC must then process it. This can take a few days. Note that you will need Lama's ComputeCanada identification code (the CCRI).


## 1. Setting up the connection [Optional]

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


## 3. Transferring data

### File storage

There are different storage partitions on CC, each with its own purpose. They are mostly identical across clusters, too.
To check storage, you can use the CC-specific command `diskusage_report`.`
As a reminder from the presentation, here is a quick breakdown of the different directories :

| Designation | Full path                       | Usage                                                                  | Description                                                                                                                                                                                                                       |
|-------------|---------------------------------|------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| home        | /home/<username>                | Source code, Python venv, App image                                    | Main directory, meant for storing                                                                                                                                                                                                 |
| projects     | ~/projects/def-lseoud/<username> | Datasets (compressed if possible), job scripts                         | 10TB storage space for the entire lab. To share a file, save it in the `group_writable` directory. Relatively fast filesystem.                                                                                                    |
| nearline    | ~/nearline                      | Inactive data.                                                         | Tape-based storage for archiving unused data. Only for files ranging from 100MB to ~1TB. Do not often write data to this directory.                                                                                               |
| scratch     | ~/scratch                       | Temporary storage, e.g. checkpoints or large datasets during training. | Temporary storage, files older than 60 days are purged (after reminder email). Useful to extract large datasets during job execution as it is a fast filesystem. Do not try to abuse by artificially modifying the age of a file. |
|             |                                 |                                                                        |                                                                                                                                                                                                                                   |

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
`-czf` = **c**reate **z**ip **f**ile
`-xzf` = e**x**tract **z**ip **f**ile

As a side note, you can also use the `zip` command to compress and decompress files. It is however less efficient than `tar` for large datasets.

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

> ### test


## 4. Interactive Session

Now we can start ! We'll kick it off 