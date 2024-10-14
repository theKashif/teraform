# Configure the AWS variables
variable "aws_region" {
  description = "AWS region"
  type = string
  default = "us-east-1"
}

# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

# Configure the AWS
provider "aws" {
  region = var.aws_region
}

# Create a new EC2 instance
resource "aws_instance" "ec2server" {
  ami = "ami-0ebfd941bbafe70c6"
  instance_type = "t2.micro"
  key_name = "aws_login"
  tags = {
    Name = "terraform-ec2"
  }
}
