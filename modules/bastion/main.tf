# Bastion security group creation to allow only ssh

resource "aws_security_group" "demo-bastion-sg" {
  name   = "demo-bastion-sg"
  vpc_id = var.vpc_cidr.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "name" = "demo-bastion-sg-ssh"
  }
}

# To create a new key pair for ssh 

resource "aws_key_pair" "demo_app_key" {
  count      = var.create_new_key_pair ? 1 : 0
  key_name   = var.ssh_key_pair_name
  public_key = file(var.ssh_key_filename)

  lifecycle {
      ignore_changes = [public_key]
    }
}

# Checking the ubuntu based AMI tag for demo and using it to launch a bastion server

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# To create a bastion server based on above AMI image tag

resource "aws_instance" "demo-bastion-server" {
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = var.create_new_key_pair ? element(concat(aws_key_pair.demo_app_key.*.key_name, [""]), 0) : var.key_pair_existing
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnets_id[0]
  vpc_security_group_ids      = ["${aws_security_group.demo-bastion-sg.id}"]
  associate_public_ip_address = true
  tags = {
      Name = "demo-bastion-host"
    }
}