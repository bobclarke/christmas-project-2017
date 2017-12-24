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
