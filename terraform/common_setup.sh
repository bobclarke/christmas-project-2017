#!/bin/bash

# Remove stuff we don't need
sudo yum remove \
  docker \
  docker-common \
  docker-selinux \
  docker-engine-selinux \
  docker-engine \
  docker-ce

# Setup yum
#sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
#sudo yum-config-manager --enable docker-ce-edge
#sudo yum-config-manager --enable docker-ce-test
#sudo yum-config-manager --disable docker-ce-edge

# Install packages
sudo yum install -y \
  git \
  ansible \

sleep 3

# Populate hosts file
sudo bash -c "cat >> /etc/hosts" << "EOF"
10.0.1.100  ansible
10.0.1.101  kube_controller
10.0.1.102  kube_node_1
10.0.1.103  kube_node_2
10.0.1.104  kube_node_3
EOF

sleep 3

# Create ansible account, set password, add ssh keys and setup sudoers
sudo useradd -m -u 30000 ansible
echo -e "ansible\nansible\n" | sudo passwd ansible
sudo bash -c "cat > /etc/sudoers.d/10_ansible" << "EOF"
ansible ALL=(ALL) NOPASSWD: ALL
EOF


