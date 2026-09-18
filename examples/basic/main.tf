provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = var.env_prefix
      App         = var.app_name
      ManagedBy   = "Terraform"
    }
  }
}

variable "asg_max_size" {
    description = "The maximum size of the Auto Scaling group."
    type        = number
    default     = 1
}

variable "asg_min_size" {
    description = "The minimum size of the Auto Scaling group."
    type        = number
    default     = 0
}

variable "app_name" {
  description = "Name of the application"
  type        = string
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

variable "env_prefix" {
  description = "Environment prefix for naming resources"
  type        = string
}

variable "external_subnets_specs" {
    description = "Specifications for the external subnets to be created"
    type        = map(object({
        avail_zone = string
        cidr_block = string
    }))
}

variable "internal_subnets_specs" {
    description = "Specifications for the internal subnets to be created"
    type        = map(object({
        avail_zone = string
        cidr_block = string
    }))
    default     = {}
}

variable "service_name" {
  type        = string
  description = "Name of the service"
}

variable "task_definition_name" {
  type        = string
  description = "Name of the task definition"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

resource "aws_vpc" "module_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

module "ecs_cluster_with_asg_capacity_provider" {
  source                          = "../.."
  elb_enabled                     = true
  asg_max_size                    = var.asg_max_size
  asg_min_size                    = var.asg_min_size
  ami_id                          = var.ami_id
  cluster_name                    = var.cluster_name
  container_definitions_file_path = var.container_definitions_file_path
  desired_count                   = var.desired_count
  env_prefix                      = var.env_prefix
  external_subnets_specs          = var.external_subnets_specs
  internal_subnets_specs          = var.internal_subnets_specs
  instance_type                   = var.instance_type
  service_name                    = var.service_name
  task_definition_name            = var.task_definition_name
  vpc_id                          = aws_vpc.module_vpc.id
}
