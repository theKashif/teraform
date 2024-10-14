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

# locals for user's data - read users.yaml file and decode it as well
locals {
  user_data = yamldecode(file("./users.yaml")).users

  # prepareing user data for roles | for policies attachmenting
  # making lists if the user object containes multiple role policies
  # using flatten list for simplicity
  user_role_pair = flatten([for user in local.user_data : [for role in user.roles : {
    username = user.username
    role     = role
  }]])
}

# output for data
output "data" {
  value = local.user_role_pair
}

# Creating users
resource "aws_iam_user" "users" {
  for_each = toset(local.user_data[*].username)
  name     = each.value
}

# Creating Users profiles/passwords
resource "aws_iam_user_login_profile" "profile" {
  for_each        = aws_iam_user.users
  user            = each.value.name
  password_length = 8
  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }
}

# lets attach policies/roles to users
resource "aws_iam_user_policy_attachment" "main" {
    # create multiple instances based of username and roles
    for_each = {
        for pair in local.user_role_pair:
        "${pair.username} - ${pair.role}" => pair
    }
    user = aws_iam_user.users[each.value.username].name
    policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
}