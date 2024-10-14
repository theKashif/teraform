terraform {}

# Number list
variable "num_list" {
  type    = list(number)
  default = [0, 1, 2, 3, 4, 5]
}

# Object list of persons
variable "person_list" {
  type = list(object({
    fname = string
    lname = string
    age   = number
  }))
  default = [{
    fname = "Kashif"
    lname = "Shehzad"
    age   = 23
    }, {
    fname = "Asif"
    lname = "Shahzad"
    age   = 20
  }]
}

# Map list of numbers
variable "map_list" {
  type = map(number)
  default = {
    "zero" = 0
    "one"  = 1
    "two"  = 2
  }
}

# Calculations in terrafomr
locals {
  add = 2 + 3
  mul = 3 * 5
  eq  = 2 != 3

  # Double all numbers in the list
  Double = [for num in var.num_list : num * 2]

  # Get only odd numbers
  odd = [for num in var.num_list : num if num % 2 != 0]

  # Get only first name from the person_list
  fnames = [for name in var.person_list : name.fname ]

  # Get only first value of the map_list
  first_value = [for key, value in var.map_list : value]

  # Get double values of the map_list
  double_values = {for key, value in var.map_list : key => value*2 }
}

# Here is the Output
output "output" {
  value = local.double_values
}
