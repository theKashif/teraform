terraform {}

locals {
  value = "Hello world!"
}

variable "string_list" {
  type    = list(string)
  default = ["value1", "value2", "value3", "value1"]
}

output "output" {
  #   value = lower(local.value)
  #   value = upper(local.value)
  # value = startswith(local.value, "H")
  # value = split(" ", local.value)
  # value = max(1, 2, 3, 4, 6)
  # value = min(1, 2, 3, 4, 6)
  # value = abs(-15.123)

#   value = length(var.string_list)
# value = join(" : ", var.string_list)
# value = contains(var.string_list, "value1")
value = toset(var.string_list)


}
