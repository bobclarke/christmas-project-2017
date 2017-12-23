# christmas-project-2017

## Overview

Build a bunch of VMS on aws with terrarform

Set these up as a kubernetes cluster

On this cluster run a bunch of containers for Jenkins, splunk, sonar, prometheus, selenium grid (ie everything you  would need for automated testing)

write a reference app (nothing fancy and I haven't yet decided which language) and test it on this platform.

The aim is to:
* Build on the BDD testing learned recently.

* learn kubernetes and while I'm at it throw in a bit of Splunk and prometheus

* try out Spinaker and chaos monkey if I get time


## How to use

We use terraform to build a VPC with two EC2 instances and associated subnets in two availablity zones. Also adds an internet gateway, security groups and an EFS share with mount points in the two avaialblity zones

Once the instances are built Terraform invokes Ansible to install Python and an NFS client on the two instances.

- Install the AWS CLI tools on your local workstation (http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
- Install Terraform and Ansible on your local workstation
- Create an AWS ssh keypair (or choose an exiting one to use)
- Clone this repo
- change the value of private_key_path in variables.tf to point at your private ssh key
- Create a terraform.tfvars file with the following contents
> secret_key = "your_aws_secret_key"

> access_key = "your_aws_access_key"

> key_name = "your_aws_ssh_key_name"  
- run terraform plan to check your config
- if all is well run terraform apply

### Todo
Mount the EFS file system on the EC2 instances

