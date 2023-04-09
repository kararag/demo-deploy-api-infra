# Application load balancer output 

output "aws_lb_id" {
  value = aws_lb.demo-lb.id
}

output "aws_lb_dns" {
  value = aws_lb.demo-lb.dns_name
}

output "aws_lb_name" {
  value = aws_lb.demo-lb.name
}

output "aws_lb_tg" {
  value = aws_lb_target_group.demo-app-http-tg.name
}

output "aws_lb_tg_id" {
  value = aws_lb_target_group.demo-app-http-tg.arn
}
