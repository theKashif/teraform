
# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "bucket name here"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}

# Configure the AWS
provider "aws" {
  region = "us-east-1"
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
