#!/bin/bash

# Define the new username
username="hardeneduser"
group="devs"

# Create group if it doesn't exist
if ! getent group "$group" >/dev/null; then
    echo "Creating group: $group"
    sudo groupadd "$group"
fi

# Create user if it doesn't exist
if id "$username" &>/dev/null; then
    echo "User $username already exists. Exiting."
    exit 1
fi

echo "Creating user: $username and adding to group: $group"
sudo adduser --ingroup "$group" "$username"

# Set up SSH for the user
user_home="/home/$username"
ssh_dir="$user_home/.ssh"
sudo -u "$username" mkdir -p "$ssh_dir"
sudo chmod 700 "$ssh_dir"

# Generate SSH key pair
ssh_key="$ssh_dir/id_rsa"

if [ ! -f "$ssh_key" ]; then
    echo "Generating SSH key pair for user: $username"
    sudo -u "$username" ssh-keygen -t rsa -b 4096 -N "" -f "$ssh_key"
else
    echo "SSH key already exists for $username, skipping key generation."
fi

sudo chmod 600 "$ssh_dir/id_rsa"
sudo chmod 644 "$ssh_dir/id_rsa.pub"

# Set up authorized keys
sudo -u "$username" cp "$ssh_dir/id_rsa.pub" "$ssh_dir/authorized_keys"
sudo chmod 600 "$ssh_dir/authorized_keys"

# Secure user home directory
sudo chown -R "$username:$group" "$user_home"
sudo chmod 750 "$user_home"

# Disable password login
echo "Disabling password login for user: $username"
sudo passwd -l "$username"

echo "User $username has been created with SSH key authentication."
