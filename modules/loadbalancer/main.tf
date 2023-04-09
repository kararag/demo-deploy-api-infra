locals {
  alb_root_account_id = "718504428378" # valid account id for Mumbai Region. Full list -> https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html
}

# Creating the s3 bucket for HTTP alb logs and attaching the required policy

resource "aws_s3_bucket" "alb_logs" {
  bucket = var.alb_bucket_name
  force_destroy = true
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowELBRootAccount",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${local.alb_root_account_id}:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.alb_bucket_name}/*"
    },
    {
      "Sid": "AWSLogDeliveryWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${var.alb_bucket_name}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Sid": "AWSLogDeliveryAclCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${var.alb_bucket_name}"
    }
  ]
}
POLICY

  tags = {
    Name        = "${var.name}-access-logs"
    Environment = "${var.name}"
  }
}

# To create a ALB to redirect request to the API sample app on port 80. For demo purpose we are using port 80. 

resource "aws_lb" "demo-lb" {
  name               = var.name
  internal           = var.lb_internal
  load_balancer_type = var.lb_type
  security_groups    = var.security_groups
  subnets            = var.subnets


  access_logs {
    bucket  = aws_s3_bucket.alb_logs.bucket
    prefix  = "${var.name}-lb-logs"
    enabled = true
  }

  tags = {
    Environment = "${var.name}"
    Name        = "${var.name}-application"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Configuring the target group for the sample app, which will be running on port 80. 

resource "aws_lb_target_group" "demo-app-http-tg" {
  name            = "app-http-tg"
  port            = 80
  protocol        = "HTTP"
  target_type     = var.target_type
  vpc_id          = var.vpc_id
  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 300 
    matcher             = "200"
  }
}

# Adding a listner for sample app for healthchecks and target instances behind ALB

resource "aws_lb_listener" "demo_http_listner" {
  load_balancer_arn = aws_lb.demo-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo-app-http-tg.arn
  }
}
