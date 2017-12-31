#!/bin/bash

# Remove packages we don't need (we'll install the appropriate version of docker sing ansible)
sudo yum remove \
  docker \
  docker-common \
  docker-selinux \
  docker-engine-selinux \
  docker-engine \
  docker-ce

# Install packages
sudo yum install -y git ansible 

sleep 3

# Populate hosts file with AWS internal IPs
sudo bash -c "cat >> /etc/hosts" << "EOF"
10.0.1.100  ansible ip-10-0-1-100
10.0.1.101  kube_controller ip-10-0-1-101
10.0.1.111  kube_node_1 ip-10-0-1-111
10.0.1.112  kube_node_2 ip-10-0-1-112
10.0.1.113  kube_node_3 ip-10-0-1-113
EOF

sleep 3

# Create ansible account
sudo useradd -m -u 30000 ansible

# Set ansible password
echo -e "ansible\nansible\n" | sudo passwd ansible

# Set up sudoers for ansible account
sudo bash -c "cat > /etc/sudoers.d/10_ansible" << "EOF"
ansible ALL=(ALL) NOPASSWD: ALL
EOF

# Create .ssh dir in readyness for terraform provisioner to copy keys 
sudo mkdir -p /home/ansible/.ssh && sudo chown ansible /home/ansible/.ssh && sudo chmod 700 /home/ansible/.ssh

# Enable password based ssh authentication (don't need to do this but want to for debugging)
sudo sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication yes/g" /etc/ssh/sshd_config 
sleep 3
sudo systemctl restart sshd
