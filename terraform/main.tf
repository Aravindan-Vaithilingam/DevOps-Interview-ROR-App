locals {
  name = "${var.project_name}-${var.environment}"
  tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}

module "vpc" {
  source               = "./modules/vpc"
  name                 = local.name
  cidr_block           = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  tags                 = local.tags
}

module "security_groups" {
  source         = "./modules/security_groups"
  name           = local.name
  vpc_id         = module.vpc.vpc_id
  container_port = var.container_port
  tags           = local.tags
}

module "ecr" {
  source = "./modules/ecr"
  name   = local.name
  tags   = local.tags
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.s3_bucket_name
  tags        = local.tags
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  name   = "/ecs/${local.name}"
  tags   = local.tags
}

module "iam" {
  source        = "./modules/iam"
  name          = local.name
  s3_bucket_arn = module.s3.bucket_arn
  tags          = local.tags
}

module "alb" {
  source                     = "./modules/alb"
  name                       = local.name
  vpc_id                     = module.vpc.vpc_id
  subnet_ids                 = var.load_balancer_internal ? module.vpc.private_subnet_ids : module.vpc.public_subnet_ids
  security_group_id          = module.security_groups.alb_security_group_id
  container_port             = var.container_port
  health_check_path          = var.health_check_path
  certificate_arn            = var.certificate_arn
  load_balancer_internal     = var.load_balancer_internal
  enable_deletion_protection = var.enable_deletion_protection
  tags                       = local.tags
}

module "rds" {
  source                = "./modules/rds"
  name                  = local.name
  subnet_ids            = module.vpc.private_subnet_ids
  security_group_id     = module.security_groups.rds_security_group_id
  database_name         = var.database_name
  username              = var.database_username
  password              = var.database_password
  instance_class        = var.database_instance_class
  deletion_protection   = var.enable_deletion_protection
  backup_retention_days = var.database_backup_retention_days
  tags                  = local.tags
}

module "ecs" {
  source                  = "./modules/ecs"
  name                    = local.name
  region                  = var.aws_region
  image                   = "${var.ecr_image}:${var.image_tag}"
  container_name          = var.container_name
  container_port          = var.container_port
  cpu                     = var.ecs_cpu
  memory                  = var.ecs_memory
  desired_count           = var.ecs_desired_count
  execution_role_arn      = module.iam.task_execution_role_arn
  task_role_arn           = module.iam.task_role_arn
  log_group_name          = module.cloudwatch.log_group_name
  subnet_ids              = module.vpc.private_subnet_ids
  security_group_id       = module.security_groups.ecs_security_group_id
  target_group_arn        = module.alb.target_group_arn
  infrastructure_role_arn = module.iam.ecs_infrastructure_role_arn
  instance_profile_arn    = module.iam.ecs_instance_profile_arn
  environment = {
    container = merge(var.app_environment, {
      RDS_DB_NAME    = module.rds.database_name
      RDS_USERNAME   = var.database_username
      RDS_PASSWORD   = var.database_password
      RDS_HOSTNAME   = module.rds.address
      RDS_PORT       = tostring(module.rds.port)
      S3_BUCKET_NAME = module.s3.bucket_name
      S3_REGION_NAME = var.aws_region
      LB_ENDPOINT    = module.alb.dns_name
    })
    deployment_maximum_percent         = var.ecs_deployment_maximum_percent
    deployment_minimum_healthy_percent = var.ecs_deployment_minimum_healthy_percent
  }
  secrets = var.app_secrets
  tags    = local.tags

  depends_on = [module.alb]
}
