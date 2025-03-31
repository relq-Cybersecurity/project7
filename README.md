# Cloud Security / Cloud DevOps / Sys Admin

I want to start with a simple Terraform script to deploy a hardened Linux server on AWS, or are you looking for a more complex setup with networking, security groups, and automated configurations

**1.Install Terraform and AWS CLI**

Before running the Terraform script, ensure you have Terraform and AWS CLI installed.

Run:
```
terraform -version
aws --version

```
If not installed, install them:

Then, configure AWS CLI:

```
aws configure
```

This will ask for:

 -AWS Access Key ID

 -AWS Secret Access Key

 -Default region (e.g., us-east-1)

 -Default output format (json is fine)


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
**5.  Connect to the Server**

Once deployed, Terraform will output the public IP address of your server.

To connect:

```
ssh -i ~/.ssh/id_rsa hardeneduser@YOUR_SERVER_IP

```
Replace YOUR_SERVER_IP with the actual instance public IP.

```hardeneduser``` is the user created by ```setup.sh```.



