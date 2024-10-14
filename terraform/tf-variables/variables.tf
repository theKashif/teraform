# declared instance type variable
variable "aws_instance_type" {
  description = "What type of instance you want to create?"
  type        = string
  validation {
    condition     = contains(["t2.nano", "t2.micro"], var.aws_instance_type)
    error_message = "Instance type must be t2.nano or t2.micro"
  }
}


# declared instance size variable
variable "aws_volume_size" {
  description = "Enter volume size"
  type        = number
  default     = 20
}


# declared instance type variable
variable "aws_volume_type" {
  description = "Enter volume type"
  type        = string
  default     = "gp2"
}


# Declared an object of instance type and size varlables
variable "ec2_volume" {
  type = object({
    v_size = number
    v_type = string
  })
  # default = {
  #   v_size = 20
  #   v_type = "gp2"
  # }
}


# Map additional tags
variable "additional_tags" {
  type = map(string) # expecting key = value format
  default = {}
}