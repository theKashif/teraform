aws_instance_type = "t2.micro"
ec2_volume = {
    v_size = 30
    v_type = "gp2"
}

additional_tags = {
    TEAM = "Development"
    PROJECT = "tf-vars"
}