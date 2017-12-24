variable "access_key" {}
variable "secret_key" {}
variable "key_name" {}
variable "private_key_path" {
	default =  "~/ec2/keys/clarkeb.pem"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_amis" {
  default = {
    us-east-1 = "ami-ae7bfdb8"
    us-west-1 = "ami-7c280d1c"
  }
}

