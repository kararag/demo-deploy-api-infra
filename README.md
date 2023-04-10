## To deploy a sample node demo api app in the AWS infra with terraform. 

This includes 6 modules as below - 

1. Bastion

`
To have a bastion server in the public subnet which allows ssh on port 22 and to be a jumpserver to the resources running in the private subnet
`

2. launchConfig 

`
This defines the launch config of the demo sample app which is configured to run on port 80, as well as the autoscaling group and it's scaling rule applied for the same. Here we are using a docker image in the init script to expose service with load balancer and most importantly, for demo purpose spot nodes are being used for the same.
`

3. LoadBalancer

`
This module is responsible for creating ALB for our sample app and configuring the health checks and attaching the target groups for the ASG. As demo we are using a public face ALB to redirect request to the app on port 80.
`

4. RDS

`
This creates the default postgres RDS engine for the demo purpose, and it's security group rule. This is a private, and only allow request from the application security group. Based on the input vars passed in tf.vars file it can be changed based on use-case. 
`


5. SecurityGroup

`
This is a separate module to handle the security group involed and its rule for Load balancer as well as the application. 
`

6. VPC

`
VPC module configures the network components which starts from creating the custom VPC, IG, NAT, two subnets (private and public), and their routes. This is where the complete demo proeject will be deployed. This is for two AZ. 
`

To sum up the resources that will be created with this -

```
VPC
IG, NAT, Subnets, route tables
Security groups for LB and app
RDS (by default multi AZ is false, can be enabled in code)
Spot node launch config with ASG configured and it's scaling rule for the demo app (by default count is 1 and max is 2)
Load balancer and it's target group and health checks configured to listen on port 80
A on-demand bastion host that will be a jumpserver for ssh
```

Below is the terraform graph for the plan output for reference the flow - 

![graph](https://user-images.githubusercontent.com/107810255/230816677-3703111d-ad87-48d4-a130-e32c7fe77fc0.png)



# Installation 

1. Clone this repo 

``
$ git clone git@github.com:kararag/demo-deploy-api-infra.git
``

2. Set the S3 bucket name to terraform state file

``
$ Update the bucket name in backend.tf
``

3. Once above is set, it uses and picks the default values from the tf.vars. Please refer file terraform.tfvars. Have marked the comments for the inputs vars which can be re-configured for the demo app. 
