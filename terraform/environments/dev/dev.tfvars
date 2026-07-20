project_name   = "myapp"
environment    = "dev"
s3_bucket_name = "myapp-dev-data-unique-suffix"

ecr_image = "123456789012.dkr.ecr.ap-south-1.amazonaws.com/myapp-dev"
image_tag = "latest"

vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.0.0/20", "10.0.16.0/20"]
private_subnet_cidrs = ["10.0.128.0/20", "10.0.144.0/20"]

# Use the least supported PostgreSQL RDS instance and a small ECS task size.
database_instance_class                = "db.t4g.micro"
ecs_cpu                                = 256
ecs_memory                             = 512
ecs_desired_count                      = 1
ecs_deployment_maximum_percent         = 200
ecs_deployment_minimum_healthy_percent = 100

# false creates an internet-facing ALB in public subnets; true creates an internal
# ALB in private subnets.
load_balancer_internal = false

# Provide the database password via TF_VAR_database_password rather than this file.
