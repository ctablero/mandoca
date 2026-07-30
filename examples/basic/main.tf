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

variable "alb_subnets_specs" {
  description  = "A map of subnet specifications for ALB instances. Each key is a unique identifier for the subnet, and the value is an object containing 'cidr_block' and 'avail_zone'."
  type         = map(object({
    cidr_block = string
    avail_zone = string
  }))
  # Example alb subnets specs, replace with your own
  default      = {
    "subnet-3" = {
        avail_zone = "us-east-1a"
        cidr_block = "10.2.3.0/24"
    }
    "subnet-4" = {
        avail_zone = "us-east-1b"
        cidr_block = "10.2.4.0/24"
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

variable "service_name" {
  type        = string
  description = "Name of the service"
}

variable "subnets_specs" {
  description  = "A map of subnet specifications for ASG instances. Each key is a unique identifier for the subnet, and the value is an object containing 'cidr_block' and 'avail_zone'."
  type         = map(object({
    cidr_block = string
    avail_zone = string
  }))
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

### ALB related resources.
/*
###
*/


module "ecs_cluster_with_asg_capacity_provider" {
  source                                   = "../.."
  alb_security_group_ingress_rule_creation = true
  alb_security_group_id                    = aws_security_group.alb_security_group.id
  asg_max_size                             = var.asg_max_size
  asg_min_size                             = var.asg_min_size
  ami_id                                   = var.ami_id
  cluster_name                             = var.cluster_name
  container_definitions_file_path          = var.container_definitions_file_path
  desired_count                            = var.desired_count
  env_prefix                               = var.env_prefix
  instance_type                            = var.instance_type
  load_balancers_list                      = [
    {
      target_group_arn = aws_alb_target_group.stack_alb_target_group.arn
      container_name   = "sample-ec2-provider-app" # Replace with your container name
      container_port   = 80 # Replace with your container port
    }
  ]
  service_name                    = var.service_name
  subnets_specs                   = var.subnets_specs
  task_definition_name            = var.task_definition_name
  vpc_id                          = aws_vpc.module_vpc.id
}
