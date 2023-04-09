variable "region" {
  description = "Region for bastion server."
  default     = "ap-south-1"
}

variable "create_new_key_pair" {
  type        = bool
  description = "If to create key pair or not"
}
variable "ssh_key_pair_name" {
  type        = string
  description = "SSH key-pair key name"
}

variable "ssh_key_filename" {
  type        = any
  description = "public key file"
}

variable "key_pair_existing" {
  description = "If create_new_key_pair is false, provide existing key pair name here."
  type        = string 
}

variable "vpc_cidr" {
  description = "VPC cidr"
  type        = any
}

variable "instance_type" {
  type        = any
  description = "Instance type to launch"
}

variable "public_subnets_id" {
  description = "Public subet range to launch bastion host"
  type        = any
}