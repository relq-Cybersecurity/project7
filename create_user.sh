#!/bin/bash


read -p "Enter the new username: " username


group="devs"


if ! getent group "$group" >/dev/null; then
    echo "Creating group: $group"
    groupadd "$group"
fi


echo "Creating user: $username and adding to group: $group"
adduser --ingroup "$group" "$username"


user_home="/home/$username"
ssh_dir="$user_home/.ssh"
 mkdir -p "$ssh_dir"
 chmod 700 "$ssh_dir"
chown "$username":"$group" "$ssh_dir"

echo "Generating SSH key pair for user: $username"
sudo ssh-keygen -t rsa -b 4096 -f "$ssh_dir/id_rsa"


 chmod 600 "$ssh_dir/id_rsa"
 chmod 644 "$ssh_dir/id_rsa.pub"


 cp "$ssh_dir/id_rsa.pub" "$ssh_dir/authorized_keys"
 chmod 600 "$ssh_dir/authorized_keys"
chown -R "$username":"$group" "$user_home"

#echo "Disabling password login for user: $username"
passwd -l "$username"

echo "User $username has been created with SSH key authentication."
echo "The private key is located in $ssh_dir/id_rsa (DO NOT SHARE THIS FILE)."
