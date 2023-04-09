variable "region" {
  description = "AWS region when resouces should be created"
  default     = "ap-south-1"
}

variable "environment" {
  type        = string
  description = "Deployment Environment"
  default     = "demo"
}

variable "vpc_cidr" {
  description = "CIDR block of the vpc"
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "CIDR block for Public Subnet"
  default     = ["10.0.16.0/20", "10.0.32.0/20"]
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "CIDR block for Private Subnet"
  default     = ["10.0.112.0/20", "10.0.144.0/20"]
}

variable "create_new_key_pair" {
  description = "To create key pair or not"
  default     = false
}
variable "ssh_key_filename" {
  description = "public key file path"
  default     = "~/.ssh/id_rsa.pub"
}
variable "key_pair_existing" {
  description = "If create_new_key_pair is false, provide existing key pair name here."
  default     = "key-pair-name-already-available"
}

variable "instance_type" {
  type        = string
  description = "Instance type of spot instance"
  default     = "t2.micro"
}

## Load Balancer

variable "lb_type" {
  type        = string
  description = "Type of load balancer"
  default     = "application"
}

variable "lb_internal" {
  type        = bool
  description = "For internal, it should be 'true'"
  default     = false
}

variable "target_type" {
  type        = string
  description = "Target type of the Target group"
  default     = "instance"
}

variable "desired_capacity" {
  type        = number
  description = "Desired capacity in Autoscaling group"
  default     = 1
}

variable "min_size" {
  type        = number
  description = "Min capacity in Autoscaling group"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Max capacity in Autoscaling group"
  default     = 2
}


variable "root_volume_size" {
  type        = number
  description = "Root volume size for EC2"
  default     = 8
}

variable "spot_price" {
  type        = any
  description = "Spot instance max price"
  default     = 0.0037
}

variable "storage" {
  type        = any
  default     = 10
} 

variable "engine" {
  type        = any
  default     = "postgresql" 
} 


variable "instance_class" {
  type        = any
  default     = "db.t3.micro" 
} 

variable "db_name" {
  type        = any
  default     = "testdb" 
} 

variable "db_username" {
  type        = any
  default     = "test" 
} 

variable "db_pass" {
  type        = any
  default     = "admin@123"
} 
