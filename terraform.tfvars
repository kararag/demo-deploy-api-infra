# AWS region;  Mandatory to pass region name
region          = "ap-south-1" #CHANGEME

# Environment name; Mandatory to pass any env/app name
environment     = "demo" #CHANGEME

# VPC cidr block; Mandatory to pass VPC CIDR
vpc_cidr        = "10.0.0.0/16" #CHANGEME

# Public subnet range; Mandatory to pass subnets CIDR
public_subnets_cidr     = ["10.0.16.0/20", "10.0.32.0/20"] #CHANGEME

# Private subnet range; Mandatory to pass subnets CIDR
private_subnets_cidr     = ["10.0.112.0/20", "10.0.144.0/20"] #CHANGEME

## BASTION HOST

# To create a new key pair or use an existing one; Mandatory to set to "true"
create_new_key_pair = "true"

# Full path of the SSH public key; Mandatory to pass when "create_new_key_pair" is set to "true"
ssh_key_filename     = "~/.ssh/demo-bastion.pub" #CHANGEME

# Pass the name of existing key pair; else mandatory to use a new key pair by setting "create_new_key_pair" is set to "true"
key_pair_existing = "demo-bastion" #CHANGEME

# Type of ec2 instance; Default keeping as "t2.micro" type
instance_type     = "t2.micro" #CHANGEME 

# Load balancer type; For the demo purpose we are using ALB
lb_type     = "application"

# Public facing or internal load balancer; Mandatory to keep as "false" for internet facing
lb_internal     = false

# RDS (this for demo, multi AZ is disabled to enable in back please set the multi_az argument to "true" from rds module )

# Storage size for the RDS instance 
storage  = "20" #CHANGEME

# Type of instance for RDS
instance_class  = "db.t3.micro" #CHANGEME

# Pass the RDS as postgres, as the the security group rule is hardcoded for this app to 5432. So it's recommeneded to use the engine as postgres
engine = "postgres"

# DB name of the RDS. 
db_name   = "demotest" #CHANGEME

# DB password for the RDS (not recommended to pass here)
db_pass   = "superadmin" #CHANGEME

# DB username for the RDS (not recommended to pass here)
db_username  = "testuser" #CHANGEME
