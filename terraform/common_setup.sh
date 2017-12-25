#!/bin/bash

# Populate hosts file
cat <<EOF >> /etc/hosts
# 
# Entries for Kubernetes
#
10.0.1.100	ansible
10.0.1.101	kube_controller
10.0.1.102	kube_node_1
10.0.1.103	kube_node_2
10.0.1.104	kube_node_3
EOF

# Remove stuff we don't need
sudo yum remove \
  docker \
  docker-common \
  docker-selinux \
  docker-engine-selinux \
  docker-engine \
  docker-ce

# Setup yum
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum-config-manager --enable docker-ce-edge
sudo yum-config-manager --enable docker-ce-test
sudo yum-config-manager --disable docker-ce-edge

# Install packages
sudo yum install -y \
  epel-release \
  git \
  ntp \
  ansible \
  yum-utils \
  device-mapper-persistent-data \
  lvm2 \
  docker-ce

# Start services
systemctl enable ntpd && systemctl start ntpd && systemctl status ntpd
systemctl docker ntpd && systemctl start docker && systemctl status docker
