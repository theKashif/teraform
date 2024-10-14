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
resource "aws_s3_bucket" "website-bucket" {
  bucket        = "website-bucket-${random_string.bucket_suffix.result}"
  force_destroy = true
}

# Allow public access to the bucket
resource "aws_s3_bucket_public_access_block" "website-bucket-public-access" {
  bucket = aws_s3_bucket.website-bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Create a new bucket policy
resource "aws_s3_bucket_policy" "website-bucket-policy" {
  bucket = aws_s3_bucket.website-bucket.id
  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Sid       = "PublicReadGetObject",
          Effect    = "Allow",
          Principal = "*",
          Action    = "s3:GetObject"
          Resource  = "arn:aws:s3:::${aws_s3_bucket.website-bucket.id}/*"
        }
      ]
  })
}

# Configure the bucket as a website
resource "aws_s3_bucket_website_configuration" "website-bucket-website-configuration" {
  bucket = aws_s3_bucket.website-bucket.id

  index_document {
    suffix = "index.html"
  }

}

# Generate a random suffix for bucket name
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Upload index.html to s3 bucket
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.website-bucket.bucket
  key          = "index.html"
  source       = "./index.html"
  content_type = "text/html"
}

# Upload styles.css to s3 bucket
resource "aws_s3_object" "styles_css" {
  bucket       = aws_s3_bucket.website-bucket.bucket
  key          = "styles.css"
  source       = "./styles.css"
  content_type = "text/css"
}


# Show website URL
output "website_url" {
  value = aws_s3_bucket_website_configuration.website-bucket-website-configuration.website_endpoint
}
