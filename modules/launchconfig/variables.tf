variable "launch_configuration_name" {
  type        = string
  description = "Name of launch config"
}

variable "security_groups" {
  type        = any
  description = "Demo application security group"
} 

variable "root_volume_size" {
  type        = any
  description = "Root EBS size of the EC2"
} 
# variable "create_new_key_pair" {
#   type        = bool
#   description = "If to create key pair or not"
# }
# variable "ssh_key_pair_name" {
#   type        = string
#   description = "SSH key-pair key name"
# }

# variable "ssh_key_filename" {
#   type        = any
#   description = "public key file"
# }

# variable "key_pair_existing" {
#   description = "If create_new_key_pair is false, provide existing key pair name here."
#   type        = string 
# }

variable "instance_type" {
  type        = string
  description = "Instance type of spot instance"
}

variable "spot_price" {
  type        = any
  description = "Spot instance max price"
}

variable "autoscaling_group_name" {
  type        = string
  description = "Name of autoscaling group"
}

variable "min_size" {
  type        = number
  description = "Min capacity in Autoscaling group"
}

variable "max_size" {
  type        = number
  description = "Max capacity in Autoscaling group"
}

variable "desired_capacity" {
  type        = number
  description = "Desired capacity in Autoscaling group"
}

variable "lb_target_group_arn" {
  type        = any
}

variable "vpc_zone_identifier" {
  type        = any
}
