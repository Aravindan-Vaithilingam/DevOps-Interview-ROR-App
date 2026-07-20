variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "image" {
  type = string
}

variable "container_name" {
  type    = string
  default = "app"
}

variable "container_port" {
  type = number
}

variable "cpu" {
  type    = number
  default = 512
}

variable "memory" {
  type    = number
  default = 1024
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "log_group_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "infrastructure_role_arn" {
  description = "IAM role that ECS assumes to provision and manage ECS Managed Instances."
  type        = string
}

variable "instance_profile_arn" {
  description = "Instance profile attached to ECS Managed Instances."
  type        = string
}

variable "environment" {
  type = object({
    container                          = map(string)
    deployment_maximum_percent         = number
    deployment_minimum_healthy_percent = number
  })
  sensitive = true
}

variable "secrets" {
  type      = map(string)
  default   = {}
  sensitive = true
}

variable "tags" {
  type    = map(string)
  default = {}
}
