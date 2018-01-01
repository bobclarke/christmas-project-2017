# christmas-project-2017

## Overview

An educational project:
 
Purpose: 
* Provision 5 Centos 7 VM's on AWS using Terrarform
* Set these up as a kubernetes cluster using Ansible
* Deploy and test app accross multiple nodes 
* Create a Kubernetes Service to front the test app

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
* This will provision a VPC with the neccesary internet gateway, subnets, security groups etc, plus the following servers:
  * Ansible server
    * IP address: 10.0.1.100  
    * hostname : 10-0-1-101
    * hostname alias : ansible
  * Kubernetes master 
    * IP address: 10.0.1.101  
    * hostname : 10-0-1-101
    * hostname alias : kube_controller
  * Kubernetes minion 
    * IP address: 10.0.1.111  
    * hostname : 10-0-1-111
    * hostname alias : kube_minion_1
  * Kubernetes minion 
    * IP address: 10.0.1.112  
    * hostname : 10-0-1-112
    * hostname alias : kube_minion_2
  * Kubernetes minion 
    * IP address: 10.0.1.113  
    * hostname : 10-0-1-113
    * hostname alias : kube_minion_3

* When complete, log on to the Ansible server, su to ansible (password is ansible) and clone this repository
* cd to the ansible directory and run ***ansible-playbook -i hosts site.yml --ask-pass*** (the password is ansible)
* This will install, configure and start Kubernetes and Etcd on the above servers
