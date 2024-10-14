# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS
provider "aws" {
  region = "us-east-1"
}

# Create a new EC2 instance
resource "aws_instance" "ec2server" {
  ami           = "ami-0ebfd941bbafe70c6"
  instance_type = var.aws_instance_type
  key_name      = "aws_login"

  root_block_device {
    delete_on_termination = true
    volume_size           = var.ec2_volume.v_size
    volume_type           = var.ec2_volume.v_type
  }

  tags = merge( var.additional_tags , {
    Name = "terraform-ec2"
  })
}
