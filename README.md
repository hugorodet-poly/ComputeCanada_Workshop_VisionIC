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

