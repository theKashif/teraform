# Create a new EC2 instance
resource "aws_instance" "nginxserver" {
  ami                         = "ami-0ebfd941bbafe70c6"
  instance_type               = "t2.micro"
  key_name                    = "aws_login"
  subnet_id                   = aws_subnet.tf_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = true

  # Create a nginx server in userData
  user_data = <<-EOF
            #!/bin/bash
            sudo yum install nginx -y
            sudo systemctl start nginx
            EOF   

  tags = {
    Name = "nginxserver"
  }
}
