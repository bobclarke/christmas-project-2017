# christmas-project-2017

## Overview

Build a bunch of VMS on AWS using Terrarform

Set these up as a kubernetes cluster using Ansible

Deploy and test app accross multiple nodes 

Create a Kubernetes Service to front the test app

## How to use
* Install git and terraform on your local workstation
* Clone this repo
* Create an AWS ssh keypair (or choose an exiting one to use)
* Change the value of private_key_path in variables.tf to point at your private ssh key
* Create a terraform.tfvars file with the following contents
  *  secret_key = "your_aws_secret_key"
  *  access_key = "your_aws_access_key"
  *  key_name = "your_aws_ssh_key_name"  
* Run terraform init to download provider plugins
* Run terraform plan to check your config
* If all is well run terraform apply
* This will provision the following servers:
  *  an ansible server with an internal IP of 10.0.1.100 and an AWS label of ansible-server
  *  a kubernetes master with an internal IP of 10.0.1.101 and an AWS label of kube-controller
  *  three Kubernetes minions with internal IPs of 10.0.1.111, 112 and 113 and AWS labels of kube_minion_1, kube_minion_2 and kube_minion_3 respectively 
* When complete, log on to the Ansible server, su to ansible (password is ansible) and clone this repository
* CD to the ansible directory and run __ansible-playbook -i hosts site.yml --ask-pass__ (the password is ansible)
