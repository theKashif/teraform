# Create a output for the public IP address of the EC2 instance
output "public_ip" {
  value = aws_instance.nginxserver.public_ip
  description = "The public IP address of the EC2 instance"
}

# Create a output for EC2 url
output "ec2_url" {
  value = "http://${aws_instance.nginxserver.public_ip}"
  description = "The URL of the EC2 instance"
}