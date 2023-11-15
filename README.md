# The VisionIC's ComputeCanada Workshop
A hands-on quickstart guide to ComputeCanada (heretoforth abbreviated CC).


## Preliminary step : Create your account

First things first :
- Register for an account at [this adress](https://ccdb.alliancecan.ca/security/login). This is only your account, it won't allow you to use the clusters by itself.
- Add a role at [this adress](https://ccdb.alliancecan.ca/me/add_role). This part actually identifies you as a student under Lama's supervision. You'll then be able to access the clusters through the lab's allocation. Note that this is not instantaneous : Lama has to approve your request first, and the team at CC must then process it. This can take a few days. Note that you will need Lama's ComputeCanada identification code (the CCRI).

## Setting up the connection [Optional]

Typing your password every time is boring. You could setup a SSH connection by uploading your RSA key to the CC website.
If you are not already familiar with SSH and RSA keys, you can go check a guide or, alternatively, run the few commands below. Understanding is not needed for this part.

Inside a terminal / command prompt, type :
```bash
ssh-keygen -t rsa -b 2048
```
and press enter until it's done. This will create a new RSA key pair in your home directory, in the folder `.ssh`. For the full filepath, check the output of the command you just entered. By default, the key pair is named `id_rsa` and `id_rsa.pub` and it should be located in `C:\Users\<username>/.ssh` on Windows or `~/.ssh` on Linux. The first one is your private key, the second one is your public key. You can now upload your public key to the CC website.

Do **NOT** upload your private key anywhere ! Only the `.pub` file !

Now you can copy all the contents of your new file id_rsa.pub and paste them into the "SSH Key" section on the CC website, at [this adress](https://ccdb.alliancecan.ca/ssh_authorized_keys).

No more password typing !

