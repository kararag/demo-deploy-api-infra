
# variable "lb_name" {
#   type        = string
#   description = "Application load balancer name"
# }

variable "lb_type" {
  type        = string
  description = "Type of load balancer"
}

variable "lb_internal" {
  type        = bool
  description = "For internal, it should be 'true'"
}

variable "alb_bucket_name" {
  type        = string
  description = "Bucket for access logs"
}

variable "security_groups" {
  type        = list(string)
} 

variable "subnets" {
  type        = list(string)
} 

variable "vpc_id" {
  type        = string
} 

variable "target_type" {
  type        = string
} 

variable "target_id" {
  type        = string
} 

variable "name" {
  type        = string
} 