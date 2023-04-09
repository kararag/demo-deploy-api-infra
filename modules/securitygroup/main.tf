resource "aws_security_group" "lb" {

  name = "Load balancer security group"
  description = "Security Group for App Load Balancer"
  vpc_id = var.vpc_cidr.id

  tags = {
    Name        = "demo-lb-sg"
    ManagedBy   = "terraform"

  }
}

resource "aws_security_group_rule" "public_out" {

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}
 
resource "aws_security_group_rule" "public_in_http" {

  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id

lifecycle {
    create_before_destroy = true
  }
}

 
resource "aws_security_group" "app" {

  name = "Application Security group"
  description = "Security group for application"
  vpc_id = var.vpc_cidr.id

  tags = {

    Name        = "app-sg"
    Role        = "private-http"
    ManagedBy   = "terraform"

  }

}

resource "aws_security_group_rule" "private_out" {

  type                       = "egress"
  from_port                  = 0
  to_port                    = 0
  protocol                   = "-1"
  cidr_blocks                = ["0.0.0.0/0"]
  security_group_id          = aws_security_group.app.id

lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "private_in" {

  type                      = "ingress"
  from_port                 = 80
  to_port                   = 80
  protocol                  = "tcp"
  source_security_group_id  = aws_security_group.lb.id
  security_group_id         = aws_security_group.app.id

lifecycle {
    create_before_destroy = true
  }

}

resource "aws_security_group_rule" "private_in_bastion" {

  type                      = "ingress"
  from_port                 = 22
  to_port                   = 22
  protocol                  = "tcp"
  source_security_group_id  = var.bastion_sg
  security_group_id         = aws_security_group.app.id

lifecycle {
    create_before_destroy = true
  }


}