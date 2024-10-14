# Configure AWS Variables
variable "aws_region" {
  default     = "us-east-1"
  type        = string
  description = "AWS region"
}

# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

# Configure the AWS
provider "aws" {
  region = var.aws_region
}


# Get latest ami by Amazon
data "aws_ami" "existing-ami" {
  most_recent = true
  owners      = ["amazon"]
}

# Show output of ami
output "aws_ami" {
  value = data.aws_ami.existing-ami.id
}


# Get Security Group
data "aws_security_group" "existing-sg" {
  tags = {
    Name = "project-sg"
    Env  = "production"
  }
}

# Show output of SG
output "aws_security_group" {
  value = data.aws_security_group.existing-sg.id
}


# Get VPC
data "aws_vpc" "existing-vpc" {
  tags = {
    Name = "project-vpc"
    Env  = "production"
  }
}

# Show output of vpc
output "aws_vpc" {
  value = data.aws_vpc.existing-vpc.id
}


# Get Availablity Zones
data "aws_availability_zones" "availability_zones" {
  state = "available"
}

# Show output of Availability Zones
output "availability_zones" {
  value = data.aws_availability_zones.availability_zones.names
}


# Get account details
data "aws_caller_identity" "caller_identity" {
}

# Show account details
output "caller_identity" {
  value = data.aws_caller_identity.caller_identity.user_id
}


# Get account details
data "aws_region" "aws_region_name" {
}

# Show account details
output "aws_region_name" {
  value = data.aws_region.aws_region_name.name
}


# Get Subnet ID
data "aws_subnet" "existing-subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing-vpc.id]
  }
  tags = {
    Name = "project-subnet-public1"
    Env  = "production"
  }
}

# Show Subnet details
output "existing-subnet" {
  value = data.aws_subnet.existing-subnet.id
}


# Create EC2 Instance
resource "aws_instance" "tf-data-source" {
  ami             = "ami-0ebfd941bbafe70c6"
  instance_type   = "t2.micro"
  key_name        = "aws_login"
  security_groups = [data.aws_security_group.existing-sg.id]
  subnet_id       = data.aws_subnet.existing-subnet.id
  tags = {
    Name = "tf-data-source"
  }
}
