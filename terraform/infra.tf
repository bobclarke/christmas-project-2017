provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.aws_region}"
}

# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  tags {
		Name = "Jenkins"
	}
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "az_a_subnet" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "az_b_subnet" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "terraform_example"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_1" {
  ami           = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"
	key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id = "${aws_subnet.az_a_subnet.id}"
  availability_zone = "us-east-1a"
	tags {
		Name = "Jenkins_1"
	}

	provisioner "local-exec" {
    command = "sleep 10 && export ANSIBLE_HOST_KEY_CHECKING=false && ansible-playbook --private-key ${var.private_key_path} -i '${aws_instance.jenkins_1.public_ip},' common.yml"
	}
}

resource "aws_instance" "jenkins_2" {
  ami           = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"
	key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id = "${aws_subnet.default.id}"
  subnet_id = "${aws_subnet.az_b_subnet.id}"
  availability_zone = "us-east-1b"
	tags {
		Name = "Jenkins_2"
	}
	provisioner "local-exec" {
    command = "sleep 10 && export ANSIBLE_HOST_KEY_CHECKING=false && ansible-playbook --private-key ${var.private_key_path} -i '${aws_instance.jenkins_2.public_ip},' common.yml"
	}
}

resource "aws_route_table_association" "aa" {
  subnet_id      = "${aws_subnet.az_a_subnet.id}"
  route_table_id = "${aws_vpc.default.main_route_table_id}"
}

resource "aws_route_table_association" "ab" {
  subnet_id      = "${aws_subnet.az_b_subnet.id}"
  route_table_id = "${aws_vpc.default.main_route_table_id}"
}

# An NFS file system for the jenkins instances
resource "aws_efs_file_system" "efs" {
  creation_token = "jenkins-efs"

  tags {
    Name = "jenkins-efs"
  }
}

# Two mount points (one in each availability zone) for the efs file system
resource "aws_efs_mount_target" "efs_mnt_a" {
  file_system_id = "${aws_efs_file_system.efs.id}"
  subnet_id      = "${aws_subnet.az_a_subnet.id}"
  security_groups = ["${aws_security_group.default.id}"]
}
resource "aws_efs_mount_target" "efs_mnt_b" {
  file_system_id = "${aws_efs_file_system.efs.id}"
  subnet_id      = "${aws_subnet.az_b_subnet.id}"
  security_groups = ["${aws_security_group.default.id}"]
}
