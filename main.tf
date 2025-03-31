provider "aws" {
  region = "us-east-1"  # Change this to your AWS region
}

# Generate SSH Key Pair
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key-2"
  public_key = file("~/.ssh/id_rsa.pub")  # Ensure this file exists
}

# Security Group for SSH
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_2"
  description = "Allow SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["5.77.202.168/32"]  # Replace with your actual public IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# First EC2 Instance
resource "aws_instance" "hardened_linux_1" {
  ami                    = "ami-04b4f1a9cf54c11d0"  # Replace with a valid AMI ID
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  user_data = file("setup.sh")  # This will run the setup.sh script

  tags = {
    Name = "FirstInstance"
  }
}

# Second EC2 Instance
resource "aws_instance" "hardened_linux_2" {
  ami                    = "ami-04b4f1a9cf54c11d0"  # Replace with the same or a different AMI ID
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id] 
  user_data = file("setup.sh")  # This will run the setup.sh script

  tags = {
    Name = "SecondInstance"
  }
}

# Output the Public IPs of Both Instances
output "first_instance_ip" {
  value = aws_instance.hardened_linux_1.public_ip
}

output "second_instance_ip" {
  value = aws_instance.hardened_linux_2.public_ip
}

