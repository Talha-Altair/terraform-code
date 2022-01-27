variable "subnet_id" {
  description = "A subnet id to create the ecs service"
}

variable "aws_region" {
  description = "Region to create all resources"
}

variable "aws_access_key" {
  description = "aws_access_key"
}

variable "aws_secret_key" {
  description = "aws_secret_key"
}

variable "execution_role" {
  description = "A ecs task execution role arn"
}

variable "deployment_name" {
  description = "name of the ecs cluster"
}

variable "api_container" {
  description = "container URI for backend"
}

variable "ui_container" {
  description = "container URI for frontend"
}

variable "api_port" {
  description = "port for backend"
}

variable "ui_port" {
  description = "port for frontend"
}
