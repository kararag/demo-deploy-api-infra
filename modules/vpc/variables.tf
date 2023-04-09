variable "environment" {
  type        =  string
  description = "Deployment Environment"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "CIDR block for Public Subnet"
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "CIDR block for Private Subnet"
}

variable "region" {
  type        =  string
  description = "Region in which the bastion host will be launched"
}

variable "availability_zones" {
  type        = list(string)
  description = "AZ in which all the resources will be deployed"
}