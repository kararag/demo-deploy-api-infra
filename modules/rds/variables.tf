variable "subnets" {
  type        = list(string)
} 

variable "rds_sg" {
  type        = string
} 

variable "vpc_cidr" {
  type        = any
} 

variable "storage" {
  type        = any
} 

variable "engine" {
  type        = any
} 


variable "instance_class" {
  type        = any
} 

variable "db_name" {
  type        = any
} 

variable "db_pass" {
  type        = any
} 

variable "db_username" {
  type        = any
} 
