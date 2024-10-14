# ec2 list object
variable "ec2" {
  type = list(object({
    ami           = string
    instance_type = string
  }))
}


# ec2_map object - for_each practice
variable "ec2_map" {
  # key=value (object{ami, type})
  type = map(object({
    ami           = string
    instance_type = string
  }))
}
