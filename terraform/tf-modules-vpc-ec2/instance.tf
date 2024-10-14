
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.1"

  name = "my-instance"
  ami = "ami-0fff1b9a61dec8a5f"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Name        = "my-instance"
    Terraform   = "true"
    Environment = "dev"
  }
}
