provider "aws" {
  region = "us-east-1"
}

data "aws_availability_zones" "name" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "my-vpc"
  cidr   = "10.0.0.0/16"

  azs             = data.aws_availability_zones.name.names
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.2.0/24"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name = "my-vpc"
  }
}
