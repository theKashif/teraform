resource "aws_security_group" "nginx_sg" {
  description = "Security group for nginx"
  vpc_id = aws_vpc.tf_vpc.id
 
 # Allow all traffic from the VPC on port 80
  ingress {
    from_port = 80 # HTTP 
    to_port = 80 # HTTP
    protocol = "tcp" # All traffic
    cidr_blocks = ["0.0.0.0/0"] # All IP addresses
  }

  # Allow all outbound traffic
  egress {
    from_port = 0 # All ports
    to_port = 0 # All ports
    protocol = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"] # All IP addresses
  }

  tags = {
    Name = "nginx_sg"
  }
}