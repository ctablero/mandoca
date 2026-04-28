provider "aws" {
  region = "us-east-1"
}

variable "ami_id" {
    description = "AMI ID for the workload instances"
    type        = string
    default     = "ami-0cbbe2c6a1bb2ad63" # Example AMI ID, replace with your own
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

variable "container_definitions_file_path" {
  type        = string
  description = "Path to the container definitions file"
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
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

module "ecs_cluster_with_self_managed_ec2" {
  source = "../.."
  ami_id = var.ami_id
  cluster_name = var.cluster_name
  container_definitions_file_path = var.container_definitions_file_path
  desired_count = var.desired_count
  instance_type = var.instance_type
  service_name = var.service_name
  task_definition_name = var.task_definition_name
}
