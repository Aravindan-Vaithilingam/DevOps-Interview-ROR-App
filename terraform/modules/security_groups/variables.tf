variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "database_port" {
  type    = number
  default = 5432
}

variable "tags" {
  type    = map(string)
  default = {}
}
