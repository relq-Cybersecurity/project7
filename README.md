# Cloud Security / Cloud DevOps / Sys Admin

## I want to start with a simple Terraform script to deploy a hardened Linux server on AWS, or are you looking for a more complex setup with networking, security groups, and automated configurations

**1.Install Terraform and AWS CLI**

Before running the Terraform script, ensure you have Terraform and AWS CLI installed.

Run:
```
terraform -version
aws --version

```
**If not installed, install them:**

**Install Terraform on Ubuntu**

Since you're on Ubuntu, the best way to install Terraform is not via Snap, but directly from HashiCorp.

**Step 1: Add HashiCorp Repository**

Run the following commands:

```
sudo apt update && sudo apt install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

```
**Step 2: Install Terraform**

```
sudo apt update && sudo apt install -y terraform
```

**Step 3: Verify Installation**

```
terraform -version
```
This should now display the installed Terraform version.

**Step 4: Check AWS CLI Installation**

```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update

```
Check Version

```
aws --version
```
It should now display something like: ```aws-cli/2.x.x Linux/x86_64```


Then, configure AWS CLI:

```
aws configure
```

This will ask for:

 -AWS Access Key ID

 -AWS Secret Access Key

 -Default region (e.g., us-east-1)

 -Output format (default: json)


 **2. Create Your Terraform Project**
 
Create a folder for your Terraform project:

```
mkdir terraform-hardened-server
cd terraform-hardened-server
```
Inside this folder, you need two files:

``main.tf``` → Terraform script to create an EC2 instance.

```setup.sh``` → Bash script that will run on the new instance to apply security settings.

**3. Create the Terraform Script (main.tf) and Hardening Script (setup.sh)**

  Create a new Terraform file, main.tf, with the following setup:
  
**4.  Run Terraform**

**Initialize Terraform (first-time setup):**

```
terraform init

```
**Check the Terraform plan (preview changes):**

```
terraform plan

```

**Deploy the EC2 Instance:**

```
terraform apply -auto-approve

```
If you want to completely remove existing resources before recreating them, run:

```
terraform destroy -auto-approve
terraform apply -auto-approve

```
⚠️ WARNING: This will delete all Terraform-managed resources. Only do this if you are okay with starting fresh.
**5.  Connect to the Server**

Once deployed, Terraform will output the public IP address of your server.

To connect:

```
ssh -i ~/.ssh/id_rsa hardeneduser@YOUR_SERVER_IP

```
Replace YOUR_SERVER_IP with the actual instance public IP.

```hardeneduser``` is the user created by ```setup.sh```.

**If you want deploy new AWS instance by teraform Rename Key Pair and Security Group in main.tf**

🔹Fix the Key Pair Name

```
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key-new"  # Change this name
  public_key = file("~/.ssh/id_rsa.pub")
}
```
🔹 Fix the Security Group Name

```
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_new"  # Change this name
  description = "Allow SSH access"

```
Then, run:

```
terraform apply -auto-approve

```
## Here’s a clear and complete documentation for your Bash script that automates the process of creating a new user with SSH key authentication on a Linux system:

✅ Purpose of **create_user.sh**

This script automates the process of:

Creating a new user on a Linux system

Adding the user to a specific group (devs)

Setting up secure SSH key-based authentication

Locking the user's password to enforce SSH-only login


📌 Prerequisites

Must be run as root or with sudo privileges

ssh-keygen must be available on the system

Script is designed for systems using /home/username user directories


⚙️ What It Does

**1. Prompt for Username**

Prompts the administrator to enter a new username.

**2. Check/Create Group (``devs```)**

Ensures that the group ```devs``` exists. If not, it creates it.

**3. Create User and Add to Group**

Adds the new user and assigns them to the ```devs``` group.

**4. Create ```.ssh``` Directory**

Creates ```/home/username/.ssh```

Sets permissions to ```700```

Changes ownership to the user

**5. Generate SSH Key Pair**

Generates an RSA 4096-bit key pair in the user's ```.ssh``` directory

Key files: ```id_rsa``` (private), ```id_rsa.pub``` (public)

**6.Configure authorized_keys**

Copies ```id_rsa.pub``` to ```authorized_keys```

Sets secure permissions: ```600```

**7. Lock Password Login**

Disables password login using ```passwd -l``` to enforce key-based authentication

**8. Final Output**

Notifies the admin that the user has been successfully created

Displays a message with the location of the private SSH key

**🔐 Security Notes**

The private key should never be shared

You may want to export or store the private key securely after creation

Ensure only root/admins can run this script

```
chmod +x create_user.sh
sudo ./create_user.sh
```
You’ll be prompted to enter a username. The rest is automated.



**********************************
1.Connecting to Server with SSH

Type the line below into Terminal in your physicall machin.

```
ssh <username>>@<ip-address> -p 42
```

For first let's install other softs that we need docker docker-compose

```
apt install -y sudo docker docker-compose make openbox xinit kitty firefox-esr
```
Configuring user
Add user to sudo and docker group.

```usermod -aG sudo <username> ```    ```usermod -aG docker <username>```

Verify whether user was successfully added to sudo and docker group.

```getent group sudo```

Step 5: Configuring sudo
⚠️You risk to loose your project if you type something else in this file and saved it⚠️

```vim /etc/sudoers```

🛡️If you type something wrong, it will show you the error and ask for saving like that🛡️

```sudo visudo /etc/sudoers```

Add user to root privilege

```<username> ALL=(ALL:ALL) ALL```

```reboot``` for changes to take effect.

Switch to user, from now we will work with sudo user.

```su <username>```

```cd ~/```
