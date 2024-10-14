# Configure the AWS variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

# Configure the AWS
provider "aws" {
  region = var.aws_region
}

# Create a new s3 bucket
resource "aws_s3_bucket" "s3bucket" {
  bucket = "test-bucket-${random_string.bucket_suffix.result}"
  force_destroy = true
}

# Generate a random suffix for bucket name
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Upload file to s3 bucker
resource "aws_s3_object" "bucket-data" {
  bucket = aws_s3_bucket.s3bucket.bucket
  source = "./myfile.txt"
  key    = "myfile.txt"
}