ec2 = [{
  ami           = "ami-0ebfd941bbafe70c6" # Amazon Linux
  instance_type = "t2.micro"
  }, {
  ami           = "ami-0e86e20dae9224db8" # Ubuntu
  instance_type = "t2.micro"
}]


ec2_map = {
  "ubuntu" = {
    ami           = "ami-0e86e20dae9224db8"
    instance_type = "t2.micro"
  },
  "amazon_linux" = {
    ami           = "ami-0ebfd941bbafe70c6"
    instance_type = "t2.micro"
  }
}
