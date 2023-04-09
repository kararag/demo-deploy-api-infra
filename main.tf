resource "random_id" "random_id_prefix" {
  byte_length = 2
}

locals {
  production_availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
}

module "vpc" {
  source               = "./modules/vpc"
  region               = var.region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = local.production_availability_zones

}
module "bastion" {

  source                    = "./modules/bastion"
  region                    = var.region
  vpc_cidr                  = module.vpc.vpc_id
  public_subnets_id         = module.vpc.public_subnets_id[*].id
  instance_type             = var.instance_type
  create_new_key_pair       = var.create_new_key_pair
  ssh_key_filename          = var.ssh_key_filename
  key_pair_existing         = var.key_pair_existing
  ssh_key_pair_name         = format("%s-app-key-pair", var.environment)
  
}

module "securitygroup" {
  source               = "./modules/securitygroup"
  vpc_cidr             = module.vpc.vpc_id
  bastion_sg           = module.bastion.bastion_sg

}

module "rds" {
  source               = "./modules/rds"
  vpc_cidr             = module.vpc.vpc_id
  rds_sg               = module.securitygroup.app_sg_id
  subnets              = module.vpc.private_subnets_id[*].id
  storage              = var.storage
  instance_class       = var.instance_class
  engine               = var.engine
  db_name              = var.db_name
  db_pass              = var.db_pass
  db_username          = var.db_username 
}


module "loadbalancer" {
  source               = "./modules/loadbalancer"
  name                 = format("%s-lb", var.environment)
  lb_type              = var.lb_type
  lb_internal          = var.lb_internal
  subnets              = module.vpc.public_subnets_id[*].id
  security_groups      = module.securitygroup.lb_sg_id[*].id
  alb_bucket_name      = format("%s-http-logs-alb", var.environment)
  vpc_id               = module.vpc.vpc_id.id
  target_type          = var.target_type 
  target_id            = module.loadbalancer.aws_lb_id
  
}

module "launchconfig" {
  source                    = "./modules/launchconfig"

  launch_configuration_name = format("%s-launch-config", var.environment)
  security_groups           = module.securitygroup.app_sg_id[*]
  instance_type             = var.instance_type
  spot_price                = var.spot_price
  root_volume_size          = var.root_volume_size
  autoscaling_group_name    = format("%s-asg", var.environment)
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = module.vpc.private_subnets_id[*].id
  lb_target_group_arn       = module.loadbalancer.aws_lb_tg_id

 
}
