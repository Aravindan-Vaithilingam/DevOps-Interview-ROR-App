variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.0.0/20", "10.0.16.0/20"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.128.0/20", "10.0.144.0/20"]
}

variable "s3_bucket_name" {
  type = string
}

variable "container_name" {
  type    = string
  default = "app"
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "ecr_image" {
  description = "ECR repository URI to deploy."
  type        = string
}

variable "health_check_path" {
  type    = string
  default = "/health"
}

variable "certificate_arn" {
  type    = string
  default = null
}

variable "load_balancer_internal" {
  description = "Whether the Application Load Balancer is internal. Internal ALBs use private subnets."
  type        = bool
  default     = false
}

variable "ecs_cpu" {
  type    = number
  default = 512
}

variable "ecs_memory" {
  type    = number
  default = 1024
}

variable "ecs_desired_count" {
  type    = number
  default = 2
}

variable "ecs_deployment_maximum_percent" {
  description = "Maximum percentage of desired tasks allowed during an ECS deployment."
  type        = number
  default     = 200
}

variable "ecs_deployment_minimum_healthy_percent" {
  description = "Minimum percentage of desired tasks that must remain healthy during an ECS deployment."
  type        = number
  default     = 100
}

variable "app_environment" {
  type      = map(string)
  default   = {}
  sensitive = true
}

variable "app_secrets" {
  description = "Map of container environment variable names to AWS Secrets Manager or SSM Parameter Store ARNs."
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "database_name" {
  type    = string
  default = "app"
}

variable "database_username" {
  type    = string
  default = "appadmin"
}

variable "database_password" {
  type      = string
  sensitive = true
}

variable "database_instance_class" {
  type    = string
  default = "db.t4g.medium"
}

variable "database_backup_retention_days" {
  type    = number
  default = 7
}

variable "enable_deletion_protection" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
