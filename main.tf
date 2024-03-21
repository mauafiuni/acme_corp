resource "aws_vpc" "acme_vpc" {
    cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "acme_subnet" {
  vpc_id     = aws_vpc.acme_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "acme"
  }
}



resource "aws_launch_template" "template" {
  name_prefix     = "acme_launch_template"
  image_id        = "ami-0c54bf137edcd738a" #bitnami-wordpress-6.4.3-7-r168-linux-debian-12-x86_64-hvm-ebs-nami
  instance_type   = "t2.micro"
}

resource "aws_autoscaling_group" "autoscale" {
  name                  = "acme_asg"  
  desired_capacity      = 1
  max_size              = 2
  min_size              = 1
  health_check_type     = "EC2"
  termination_policies  = ["OldestInstance"]
  vpc_zone_identifier   = [aws_subnet.acme_subnet.id]

  launch_template {
    id      = aws_launch_template.template.id
    version = "$Latest"
  }
}