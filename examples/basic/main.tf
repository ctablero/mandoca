provider "aws" {
  region = "us-east-1"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

variable "container_definitions_file_path" {
  type        = string
  description = "Path to the container definitions file"
}

variable "desired_count" {
  type        = number
  description = "Number of desired tasks"
  default     = 0
}

variable "service_name" {
  type        = string
  description = "Name of the service"
}

variable "task_definition_name" {
  type        = string
  description = "Name of the task definition"
}

#module "ecs_cluster_with_self_managed_ec2" {
#  source = "../.."
#  cluster_name = var.cluster_name
#  container_definitions_file_path = var.container_definitions_file_path
#  desired_count = var.desired_count
#  service_name = var.service_name
#  task_definition_name = var.task_definition_name
#}
#