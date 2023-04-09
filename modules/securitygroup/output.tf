# Security group components output 

output "lb_sg_id" {
  value = aws_security_group.lb
}

output "app_sg_id" {
  value = aws_security_group.app.id
}
