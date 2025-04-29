# Cloud Security / Cloud DevOps / SysAdmin Project Documentation
1. Project Overview 
   -
This project sets up a hardened Linux server infrastructure on AWS Cloud using:

 . Terraform to automate server deployment.

 . Docker Compose to manage multiple services (NGINX, WordPress, MariaDB).

 . NGINX with strict TLSv1.2/1.3 enforcement.

 . SSH hardening, Linux user management with groups/permissions.

 . Web Application Firewall and Network Firewalls.

 ..env file for environment security.

 . Automated scripts for provisioning, user creation, and server hardening.
 
---
2. Setup Guide
   -  
2.1. Install Required Tools
   -
   . Install Terraform:
```
sudo apt update && sudo apt install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y terraform
terraform -version
```
   .Install AWS CLI:
   
   ```
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version

   ```
   . Configure AWS:
   
   ```
   aws configure

   ```
Enter:

   .Access Key  ID

   .Secret Access Key

   .Region   (e.g., us-east-1)

   .Output Format (json)

2.2. Create Terraform Project
   -
  . Create project folder:
  
  ```
mkdir terraform-hardened-server
cd terraform-hardened-server

```
Files inside:

  . main.tf → Terraform script to create EC2

  . setup.sh → Bash script for server hardening
  
![ing](https://github.com/relq-Cybersecurity/project7/blob/main/Screenshot%20from%202025-03-17%2022-05-04.png)
  ---
3. Infrastructure with Terraform
   -

3.1. Deploy Hardened Linux Server
   -
Steps:

   1. Initialize Terraform:

      ```
      terraform init
      ```
   2. Plan deployment:
      ```
      terraform plan

      ```
   3. Apply deployment:
      ```
      terraform apply -auto-approve

      ```  
   4. Destroy and recreate (if needed):
      
 ```
      terraform destroy -auto-approve
      terraform apply -auto-approve

 ```
![ing](https://github.com/relq-Cybersecurity/project7/blob/main/Screenshot%20from%202025-04-20%2002-44-59.png)

**Terraform `main.tf` Summary**:

   **.SSH Key Pair**: Automatically imported from `~/.ssh/id_rsa.pub`

   **Security Group**: Only allows SSH from a specific IP (e. g., `5.77.202.168/32`)

   **EC2 Instances**:  `t2.micro` Linux VMs using a hardened AMI

   **User Data Script**: Executes `setup.sh` on instance boot
   
![ing](https://github.com/relq-Cybersecurity/project7/blob/main/Screenshot%20from%202025-03-17%2022-06-41.png)

**To deploy new instances,** rename:

```
`main.tf`

# Change key name
key_name = "deployer-key-new"

# Change SG name
name = "allow_ssh_new"
```
  
3.2. Server Hardening via `setup.sh`
---
Purpose: Create a secure Linux user with SSH key-only access

**Automates:**

   . User creation under group devs

   . SSH key generation and setup

   . Password login disablement (passwd -l)
   
On instance launch:

   . Create secure user (`hardeneduser`).

   . Create groups and permissions.

   . Setup SSH (RSA 4096-bit key, no password, only key login).

   . Disable root password login.

**Key Steps:**

   1.Create group & user

   2.Set up `` directory

   3.Generate 4096-bit RSA key pair

   4.**Setup **``

   5.Lock password login

**Security Notes:**

   . Never expose the private key

   . Store private keys securely (e.g., encrypted vault)

   . Only root/sudo should execute the script
```
chmod +x setup.sh
sudo ./setup.sh
```
 Connect:
 
```
ssh hardeneduser@<instance_ip> -p 22
```


3.3. SSH into Instance   
---
```
ssh -i ~/.ssh/id_rsa hardeneduser@<YOUR_SERVER_IP>

```

```
ubuntu@ip-172-31-82-111:/home$ ls
`hardeneduser`  `ubuntu`
```
![ing](https://github.com/relq-Cybersecurity/project7/blob/main/Screenshot%20from%202025-03-19%2023-14-48.png)

   When admin want creat new user  on terminal run ./create_user.sh

Automated User Creation Script
✅ create_user.sh functionality:

   . Create user & assign to devs group

   . Generate SSH keys

   . Lock password login

   . Set correct permissions on .ssh

🔐 Security Best Practices:

   . Only SSH login allowed

   . Keys stored securely

   . Private key needs secure export




---
4. Linux System Preparation
   ---
   Key Docker Terminology
---
| Term               | Description                                                                 |
|--------------------|-----------------------------------------------------------------------------|
| **Docker**         | Platform to develop/run containers in isolated environments                 |
| **Container**      | A runtime instance of a Docker image; runs one service                      |
| **Image**          | Blueprint/template used to launch containers                                |
| **Dockerfile**     | Script to build an image (base OS, config, dependencies)                    |
| **Docker Compose** | Tool to manage multi-container apps via `docker-compose.yml`                |
| **Service**        | In Compose: a container defined with configs                                |
| **Volume**         | Persistent storage mounted into containers                                  |
| **Network**        | Isolated virtual network for containers to communicate                      |
| **NGINX**          | Web server, reverse proxy, TLS enforcer                                     |
| **TLS**            | Encryption protocol (successor to SSL), ensures HTTPS                       |
| **WordPress**      | Open-source CMS to manage web content                                       |
| **PHP-FPM**        | Optimized PHP runtime used by WordPress                                     |
| **MariaDB**        | MySQL-compatible relational database                                        |
| **Makefile**       | Automates build/deployment processes                                        |
| **VM**             | Emulated OS environment used for isolation                                  |
| **.env file**      | Secure file for storing environment variables (passwords, ports, etc.)      |


4.1.  Docker & Services Deployment
-
Install Dependencies:
```
sudo apt install -y sudo docker docker-compose make openbox xinit kitty firefox-esr
```

4.2. Create Admin User
---
  . Add User to groups:
   ```
   sudo usermod -aG sudo <username>
   sudo usermod -aG docker <username>

   ```
. Verify  user was successfully added to sudo and docker group:
 ```
 getent group sudo
 ```

. Grant sudo permissions:
     
```
      sudo visudo
      # Add:
      <username> ALL=(ALL:ALL) ALL

```

. Reboot and switch to the user:
     
```
      reboot
      su <username>
      cd ~/

```


5. Dockerized Multi-Service Setup
   --- 

| Service              | Purpose                                |
|----------------------|----------------------------------------|
| **NGINX**            | Reverse proxy + SSL/TLS enforcement    |
| **PHP-FPM + WordPress** | Host WordPress application             |
| **MariaDB**          | WordPress database                     |
| **Volumes**          | Persistent data for MariaDB and WordPress |

    


5.1. Project Structure
---

```
      inception/
├── docker-compose.yml
├── Makefile
├── nginx/
│   ├── Dockerfile
│   ├── default.conf
│   └── ssl/
├── wordpress/
│   ├── Dockerfile
│   └── entrypoint.sh
├── mariadb/
│   ├── Dockerfile
│   └── init.sql
├── .env

```

5.2. How it Works
-
| Component | Description |
|-----------|-------------|
| NGINX     | Enforces HTTPS (TLSv1.2/1.3 only), reverse proxy to WordPress |
| PHP-FPM   | Runs WordPress PHP |
| MariaDB   | Database for WordPress |
| Volumes   | Persist database and WordPress files |
| Network   | Isolates services for security |

     

5.3. Important Docker Points
---
   .Use Alpine/Debian lightweight images.

   .One service per container (NGINX, MariaDB, PHP-FPM).

   .Restart policies set (always restart).

   .Volumes persist important data.

   .Environment variables stored securely in .env.

---
6. Security Measures
   ---   
6.1. Linux Hardening
---
   .Disable root login over SSH.

   .SSH key-only authentication (RSA 4096 bits).

   .Passwords disabled for SSH users.

   .Sudoers configured carefully.

   .Firewall rules applied (AWS SG + host firewall).
   

6.2. Web Security
---
   .NGINX enforces TLS only.

   .Certificates generated automatically if needed.

   .WordPress hardened (secure URLs, restricted permissions).

   .Hide .ht* files.

   .Use of secure PHP-FPM settings.

   .Secrets hidden via .env.
   

6.3. Docker Security
---
   .No plain-text secrets inside Compose.

   .Only needed ports are exposed.

   .Services isolated into their own containers.

   .Network encrypted.
   

7. Best Practices & Reminders
   ---   
   .Use .gitignore to exclude .env and Docker volumes from GitHub.

   .Regenerate SSL certificates before production launch.

   .Rotate AWS keys periodically.

   .Backup volumes (MariaDB + WordPress files).

   .Use healthchecks in Compose for production readiness.
   

8. Deployment
   ---  
Build and start services:

```
make start
```
Monitor logs:
```
make log
```
Reset everything (optional):
```
make clean
```

9. Access
   ---
      
   .Visit WordPress:

   `https://<your-public-ip>:4343/`

    ![ing](https://github.com/relq-Cybersecurity/project7/blob/main/Screenshot%20from%202025-04-13%2018-30-04.png)
   
   .Admin login:

   `https://<your-public-ip>:4343/wp-login.php`
   
   ![ing](https://github.com/relq-Cybersecurity/project7/blob/main/Screenshot%20from%202025-04-17%2002-18-29.png)
   
   ![ing](https://github.com/relq-Cybersecurity/project7/blob/main/Screenshot%20from%202025-04-17%2002-18-44.png)
   
   .Static Page:

   `https://<your-public-ip>:4343/wp-content/static-site/index.html`
   
   ![ing](https://github.com/relq-Cybersecurity/project7/blob/main/Screenshot%20from%202025-04-17%2002-15-55.png)
   
---
🚀 Conclusion

This project demonstrates:

✅ Automated cloud deployment (Terraform + AWS)

✅ Secure Linux administration (SSH, sudo, hardening)

✅ Dockerized scalable services (NGINX, WordPress, MariaDB)

✅ Proper security practices (TLS, secrets management)

✅ Infrastructure-as-Code principles
