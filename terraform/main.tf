#---------------------------------------------------------------
# Create:
#     - VPX, Security Group, Internet Gateway, Route Table for Website
#     - Key Pair from local file
#     - Launch configuration with Auto AMI Lookup
#     - Auto Scaling Group 
#     - Classic Load Balancer 
#     - S3 bucket to store frontend static files
#     - S3 Bucket Policy to grant public read access for website
#
# Made by Sofia Demyanovska 08-September-2020
#---------------------------------------------------------------
data "aws_ami" "latest-amazon-server" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
#---------------------------------------------------------------
resource "aws_key_pair" "puppet_theatre_back" {
  key_name   = var.key_name
  public_key = "${file(var.public_key_path)}"
  tags       = "${var.tags}"
}
#---------------------------------------------------------------
resource "aws_launch_configuration" "puppet_theatre_back" {
  name_prefix     = "WebServer-LC-"
  key_name        = var.key_name
  image_id        = data.aws_ami.latest-amazon-server.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.default.id]
  user_data       = file("user_data.sh")

  lifecycle {
    create_before_destroy = true
  }
}
#---------------------------------------------------------------
resource "aws_autoscaling_group" "puppet_theatre_back" {
  name                 = "ASG-${aws_launch_configuration.puppet_theatre_back.name}"
  launch_configuration = aws_launch_configuration.puppet_theatre_back.name
  min_size             = var.min_size
  max_size             = var.maz.size
  min_elb_capacity     = var.min_elb_capacity
  health_check_type    = "ELB"
  vpc_zone_identifier  = ["${aws_subnet.default.id}"]
  load_balancers       = [aws_elb.puppet_theatre_back.name]

  dynamic "tag" {
    for_each = {
      Name   = "Terraform Blue/Green (v${var.infrastructure_version})"
      Owner  = "Sofia Demyanovska"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
#---------------------------------------------------------------
resource "aws_elb" "puppet_theatre_back" {
  name                  = "PuppetProject-ELB"
  subnets               = [aws_subnet.default.id]
  security_groups       = [aws_security_group.default.id]

  listener {
    lb_port             = 80
    lb_protocol         = "http"
    instance_port       = 5000
    instance_protocol   = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "HTTP:5000/"
    interval            = 30
  }

  tags = {
    Name = "Puppet-thatre-ELB"
  }
}
#---------------------------------------------------------------

