# Output of the ALB dns to view sample node app

output "aws_lb_dns" {
  value = module.loadbalancer.aws_lb_dns
  description = "The load balancer DNS"
}
