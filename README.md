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
##   This project involves setting up a small infrastructure composed of different services under specific rules. The whole project has to be done in a virtual machine
📘 Fundamental Terminology
```Term | Definition
**Docker** | A platform for developing, shipping, and running applications inside containers, providing isolation and consistency.
**Docker Container** | A lightweight, standalone, and executable package that includes everything needed to run an application: code, runtime, libraries, etc.
**Docker Image** | A snapshot (template) used to create containers. It contains the application code and dependencies.
**Dockerfile** | A script file that contains instructions to build a Docker image (e.g., OS, packages, copy files, etc.).
**Docker Compose** | A tool for defining and managing multi-container Docker applications using a YAML file (docker-compose.yml).
**Service** | In Docker Compose, a service is a definition of a container. It defines what image to use, ports, volumes, environment, etc.
**Volume** | A persistent storage space used by Docker containers. Volumes keep data even if the container is deleted.
**Network (Docker)** | A virtual network that allows containers to communicate with each other securely by name.
**NGINX** | A high-performance web server that can serve static content and act as a reverse proxy, load balancer, and HTTPS enforcer.
**TLS (Transport Layer Security)** | A cryptographic protocol used to secure communication over a network (successor to SSL). Versions TLSv1.2 and TLSv1.3 are considered secure.
**WordPress** | A popular open-source content management system (CMS) for building websites and blogs.
**PHP-FPM (FastCGI Process Manager)** | A PHP interpreter optimized for performance. It allows PHP code (like WordPress) to run inside its own container.
**MariaDB** | An open-source relational database system (fork of MySQL) used by WordPress to store data.
**Makefile** | A script with commands used by the make utility to automate building, running, and managing projects.
**Virtual Machine (VM)** | An emulated computer system running its own OS, used for isolation or simulation of an environment.
**.env File** | A file used to store environment variables like database credentials, ports, and domain names in a secure way.

```
I used

Docker Compose.
Each Docker image  have the same name as its corresponding service.
Each service has to run in a dedicated container.
For performance reasons, the containers must be built from either the penultimate stable
version of Alpine or Debian. 
I also  writed Dockerfiles, one per service. The Dockerfiles must
be called in my docker-compose.yml by your Makefile.

 **The project is set up according to these points**

• A Docker container that contains NGINX with TLSv1.2 or TLSv1.3 only.

• A Docker container that contains WordPress with php-fpm (it must be installed
and configured) only, without nginx.

• A Docker container that contains only MariaDB, without nginx.

• A volume that contains your WordPress database.

• A second volume that contains your WordPress website files.

• A docker-network that establishes the connection between your containers.

 containers must restart automatically

 🧱 Service Breakdown
 
1. NGINX (TLS)
   
Runs only NGINX

Configured to support only TLSv1.2 or TLSv1.3

Uses a self-signed certificate or Let's Encrypt

Acts as a reverse proxy for WordPress

2. WordPress (with PHP-FPM)
   
No NGINX inside this container

Uses PHP-FPM to serve WordPress

Communicates with MariaDB

Uses a volume for site files

3. MariaDB
   
Runs only the MariaDB service

No web server included

Stores WordPress data

Uses a volume for the database files

🗃️ Volumes

Volume 1: /var/lib/mysql → stores MariaDB data

Volume 2: /var/www/html → stores WordPress site files

🌐 Network

A custom Docker network is used to connect NGINX, WordPress, and MariaDB

Ensures services communicate securely and by name

🔁 Restart Policy

All services must include the following in docker-compose.yml:


📁 File Structure
```
inception/
│
├── docker-compose.yml
├── Makefile
├── nginx/
│   ├── Dockerfile
│   ├── default.conf
│   └── ssl/ (cert.pem, privkey.pem)
├── wordpress/
│   ├── Dockerfile
│   └── entrypoint.sh
├── mariadb/
│   ├── Dockerfile
│   └── init.sql
├── .env
```
🚀 Build & Run

Using the provided Makefile, the entire stack is built and run via:

```
make clean     # Optional, resets everything, removes all volumes, deletes orphaned containers, deletes the generated SSL certificate files.
make start     # Builds and runs containers
make logs      # Follow service logs

```

🔒 Security Notes

TLS must be strictly enforced (TLSv1.2 or TLSv1.3).

WordPress and MariaDB passwords should be stored in .env.

NGINX should block access to hidden files (e.g. .ht*).


**my sequence of steps was as follows**

1. nginx image, Dockerfile for container and generate_cert.sh for certificates
   
2.mariadb image and Dockerfile for contenier , make checking for database

```docker exec -it mariadb mysql -u root -p``` (it will ask for rootpassword, which is specified in MARIADB_ROOT_PASSWORD by .env file) then ```SHOW DATABASES;``` you see table. 
You are now inside MariaDB, and you can see your automatically created database, mydb. At this point, you have a fully functional setup.

3.php_fpm image , Dockerfile for container and generate_cert.sh for wordpress setings

🧠 The main idea
 WordPress requires 3 things:

✅ Files (wp-config.php, index.php, etc.) → these files are in the ./wordpress_data folder.

✅ PHP-FPM, which will test the .php files → this is done by the php container.

✅ MariaDB, as a database.

PHP-FPM (Full name: PHP FastCGI Process Manager) — this is a mechanism that allows PHP scripts to run on the server more efficiently.

In simple terms,

PHP-FPM is a tool that runs your PHP code (such as WordPress files), but does so in a separate process from the server's NGINX. Since NGINX itself cannot directly understand PHP, it passes the PHP files to PHP-FPM, which "translates" them and returns the result in HTML format.

PHP-FPM provides things like:

 Processes .php files.
 Provides fast and secure PHP execution.
 Allows server offload when receiving many requests.
 
➡️ https://ip:4343/ displays the default WordPress page with the message Hello world!, meaning:

✅ PHP is running

✅ MariaDB is running

✅ WP-CLI successfully loaded WordPress

✅ NGINX and SSL are working

➡️ https://ip:4343/wp-login.php  and login admin credentals (WP_ADMIN_USER=admin  WP_ADMIN_PASSWORD=admin123) by .env file. 

 can configure wordpress.
 
➡️ https://ip:4343/wp-content/static-site/index.html

and there you will find my static page

**The program is universal,automated and can work anywhere if you enter a valid IP in .env.**

Purpose of volumes:
The WordPress volume stores the site data, code, and images (/var/www/html).

The MariaDB volume stores the database data (/var/lib/mysql).

So, it turns out that all the necessary files for storing data (the WordPress database and files, and the MariaDB data) are stored in a special db_data folder defined by you.

#### You DO NOT need to store the contents of your Docker db volumes on GitHub. They are regenerated when you run setup again. Focus only on your:

Dockerfiles
docker-compose.yml
Config files
NGINX, PHP, WordPress setups
creat .gitignore. .gitignore should be placed at the same level, in the root of your repo, and should contain

```
# Ignore DB and WordPress volumes
inception/db_data/
inception/wordpress_data/

# Ignore SSL certs
inception/nginx/ssl/

# Ignore env files (sensitive info)
inception/.env

# Ignore system files
*.DS_Store
```
``
git add .gitignore
git commit -m "Ignore volumes and sensitive files"
git push
```
Now the db will not be included in GitHub, and the repo will remain clean.

#### some command for Docker
1. Check WordPress loading in php container. You should see all WordPress files (wp-admin, wp-content, wp-includes, etc.)
```
docker exec -it php sh
ls /var/www/html
```
2. Availability of WordPress files in NGINX container. If you don't see the CSS files (style.min.css, admin.css), then NGINX simply doesn't have the ability to serve those files.
   ```
   docker exec -it nginx sh
   ls /var/www/html/wp-includes/css/

   ```
This will be a complete reset, to start over in a clean environment.

3.Stop all containers
```
docker stop $(docker ps -aq)
```

4.Delete all containers
```
docker rm $(docker ps -aq)
```

5.Delete all images (if necessary)
```
docker rmi $(docker images -q)
```

6.Delete all volumes

```docker volume prune -f
```

7.Clean and rebuild the project.
```
docker-compose build --no-cache
docker-compose up -d
```
