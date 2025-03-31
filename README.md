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
Enter the new username when prompted.

Follow the SSH key generation steps.

```
chmod +x create_user.sh
sudo ./create_user.sh
```

