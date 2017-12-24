
# Set up provider details
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.aws_region}"
}

# Create a VPC to launch our instances into
resource "aws_vpc" "kube" {
  cidr_block = "10.0.0.0/16"
  tags 	{
    Name = "kube-vpc"
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.kube.id}"
  tags 	{
    Name = "kube-int-gw"
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.kube.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

# Create a subnet to launch our instances into
resource "aws_subnet" "subnet_1" {
  vpc_id                  = "${aws_vpc.kube.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "${var.aws_region}a"
  tags 	{
    Name = "kube-subnet-1"
  }
}

# Our default security group to access our instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "kube_sec_group"
  description = "Used in the terraform"
  vpc_id      = "${aws_vpc.kube.id}"

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

resource "aws_instance" "ansible_server" {
  ami           = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id = "${aws_subnet.subnet_1.id}"
  availability_zone = "${var.aws_region}a"

  tags {
    Name = "ansible-server"
  }

	provisioner "file" {
    source      = "common_setup.sh"
    destination = "/tmp/common_setup.sh"
    connection {
      type     = "ssh"
      user     = "centos"
      private_key  = "${file("${var.private_key_path}")}"
    }
  }

	provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/common_setup.sh",
      "/tmp/common_setup.sh"
    ]
    connection {
      type     = "ssh"
      user     = "centos"
      private_key  = "${file("${var.private_key_path}")}"
    }
  }
}

resource "aws_route_table_association" "aa" {
  subnet_id      = "${aws_subnet.subnet_1.id}"
  route_table_id = "${aws_vpc.kube.main_route_table_id}"
}
