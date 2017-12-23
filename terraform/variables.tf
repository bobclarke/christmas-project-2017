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
    eu-west-1 = "ami-674cbc1e"
    us-east-1 = "ami-2757f631"
    us-west-1 = "ami-969ab1f6"
    us-west-2 = "ami-8803e0f0"
  }
}

