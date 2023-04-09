# VPC components output 

output "vpc_id" {
  value = aws_vpc.vpc
}

output "public_subnets_id" {
  value = aws_subnet.public_subnet
}

output "private_subnets_id" {
  value = aws_subnet.private_subnet
}
