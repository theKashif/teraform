# Configure the AWS variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

locals {
  project = "project - multi resource"
}

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
  region = var.aws_region
}

# Create a vpc
resource "aws_vpc" "mr_vps" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name    = "mr_vps"
    Project = "${local.project} - vpc"
  }
}

# Create a subnet using count with dynamic cidr
resource "aws_subnet" "mr_subnet" {
  vpc_id     = aws_vpc.mr_vps.id
  cidr_block = "10.0.${count.index}.0/24"
  count      = 2
  tags = {
    Name    = "mr_subnet"
    Project = "${local.project} - subnet - ${count.index}"
  }
}

#Creating 4 EC2 instances using our subnets
resource "aws_instance" "name" {
    ami = "ami-0ebfd941bbafe70c6"
    instance_type = "t2.micro"
    count = 4
    subnet_id = element(aws_subnet.mr_subnet[*].id, count.index % length(aws_subnet.mr_subnet))

    tags = {
      Name = "${local.project} - ec2 - ${count.index}"
    }
}

#Creating 2 EC2 instances with different amis using count method and using our subnets
resource "aws_instance" "name" {
    ami = var.ec2[0].ami
    instance_type = var.ec2[1].instance_type
    count = length(var.ec2)
    subnet_id = element(aws_subnet.mr_subnet[*].id, count.index % length(aws_subnet.mr_subnet))
    tags = {
      Name = "${local.project} - ec2 - ${count.index}"
    }
}

# creating 2 EC2 instances with different amis using for each method and using our subnets
resource "aws_instance" "name" {
    for_each = var.ec2_map
    # we will get each.key and each.value

    ami = each.value.ami
    instance_type = each.value.instance_type
    subnet_id = element(aws_subnet.mr_subnet[*].id, index(keys(var.ec2_map), each.key) % length(aws_subnet.mr_subnet))
    tags = {
      Name = "${local.project} - ec2 - ${each.key}"
    }
}

#output of the 0 index subnet
output "output" {
    value = aws_subnet.mr_subnet[0].id
}