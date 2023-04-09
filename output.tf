output "aws_lb_dns" {
  value = module.loadbalancer.aws_lb_dns
  description = "The load balancer DNS"
}
