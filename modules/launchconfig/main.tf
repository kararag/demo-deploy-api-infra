# To get the latest ubuntu AMI tag on filter 

data "aws_ami" "ubuntu-new" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_availability_zones" "all" {}

# Based on above AMI and using it to create a launch config and passing some user data script for a sample node app. For demo purpose we are using spot nodes

resource "aws_launch_configuration" "demo_app_lc" {

  name                  = var.launch_configuration_name
  image_id              = data.aws_ami.ubuntu-new.id
  instance_type         = var.instance_type
  spot_price            = var.spot_price
  security_groups       = var.security_groups
  key_name              = "demo-app-key-pair"
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install docker.io -y
              sudo docker pull ghcr.io/benc-uk/nodejs-demoapp:07-10-2022.1333
              sudo sleep 3
              sudo docker run -d --rm -it -p 80:3000 ghcr.io/benc-uk/nodejs-demoapp:latest
              sudo docker ps
              EOF

  root_block_device {
    volume_type = "gp2"
    volume_size = var.root_volume_size
    delete_on_termination = true
  }
  
  ebs_block_device {
    volume_type = "gp2"
    device_name = "/dev/sdb"
    volume_size = 5
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Configuring the Auto scaling group for the sample node app; min: 1 & max: 2 for demo

resource "aws_autoscaling_group" "demo_app_as" {
  name                 = var.autoscaling_group_name
  launch_configuration = aws_launch_configuration.demo_app_lc.name
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier  = var.vpc_zone_identifier
  
  enabled_metrics      = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]


  health_check_type    = "ELB"

  tag {
    key                 = "Name"
    value               = "demo-app-asg"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

}

# load balancer attachment to Autoscaling group

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.demo_app_as.name
  alb_target_group_arn   = var.lb_target_group_arn

}

# Attaching the Autoscaling policy based on CPU metrics 

resource "aws_autoscaling_policy" "demo-asg-policy" {
  
  name                   = "${var.autoscaling_group_name}-scaling-policy"
  autoscaling_group_name = aws_autoscaling_group.demo_app_as.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 40.0
  }
}
