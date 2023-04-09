# Creation for RDS security group

resource "aws_security_group" "rds-sg" {

  name = "Load balancer for RDS"
  description = "Security Group for RDS"
  vpc_id = var.vpc_cidr.id

  tags = {
    Name        = "rds-sg"
    ManagedBy   = "terraform"

  }
}

# Creation of security rule for the security group for RDS

resource "aws_security_group_rule" "public_out" {

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds-sg.id
}

# Adding inbound rule to allow only from application security group on port 5432. As demo is using the postgres RDS

resource "aws_security_group_rule" "private_in" {

  type                      = "ingress"
  from_port                 = 5432
  to_port                   = 5432
  protocol                  = "tcp"
  source_security_group_id  = var.rds_sg
  security_group_id         = aws_security_group.rds-sg.id

lifecycle {
    create_before_destroy = true
  }

}

# Creation of subnet group for sample RDS

resource "aws_db_subnet_group" "demo-rds-subnet-group" {
  name        = "demo-rds-app"
  description = "DB subnet group"
  subnet_ids  = var.subnets
}

# Creation of RDS instance in the custom VPC and passing configuration, can be modified via tf vars

resource "aws_db_instance" "demo-rds" {
  allocated_storage      = var.storage
  engine                 = var.engine
  instance_class         = var.instance_class
  identifier             = var.db_name
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_pass
  db_subnet_group_name   = aws_db_subnet_group.demo-rds-subnet-group.id
  vpc_security_group_ids = [aws_security_group.rds-sg.id]
  skip_final_snapshot    = true
  multi_az               = false
  backup_retention_period = 7
  maintenance_window      = "Fri:09:00-Fri:09:30"
}

# Configuring the snapshot for the sample

resource "aws_db_snapshot" "demo-rds-snap" {
  db_instance_identifier = aws_db_instance.demo-rds.id
  db_snapshot_identifier = aws_db_instance.demo-rds.identifier
}