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

# Create a new VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terraform-vpc"
  }
}

# Create a Private Subnet
resource "aws_subnet" "tf_private_subnet" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "terraform-private-subnet"
  }
}

# Create a Public Subnet
resource "aws_subnet" "tf_public_subnet" {
  vpc_id = aws_vpc.tf_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "terraform-public-subnet"
  }
}

# Create a Internet Gateway
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "terraform-igw"
  }
}

# Create a Route Table
resource "aws_route_table" "tf_route_table" {
  vpc_id = aws_vpc.tf_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }
}

# Create a Route Table Association for the Public Subnet
resource "aws_route_table_association" "tf_public_subnet_association" {
  subnet_id = aws_subnet.tf_public_subnet.id
  route_table_id = aws_route_table.tf_route_table.id
}

# Create a Route Table Association for the Private Subnet
resource "aws_route_table_association" "tf_private_subnet_association" {
  subnet_id = aws_subnet.tf_private_subnet.id
  route_table_id = aws_route_table.tf_route_table.id
}

# Create a new EC2 instance
resource "aws_instance" "ec2server" {
  ami = "ami-0ebfd941bbafe70c6"
  instance_type = "t2.micro"
  key_name = "aws_login"
  subnet_id = aws_subnet.tf_public_subnet.id
  tags = {
    Name = "terraform-ec2-vpc"
  }
}