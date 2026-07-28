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

resource "aws_security_group" "alb_security_group" {
    
    name = "${var.env_prefix}-alb-security-group"
    vpc_id = var.vpc_id

    tags = {
        Name = "${var.env_prefix}-alb-security-group"
    }
}

resource "aws_security_group_rule" "alb_security_group_rule_http_inbound_worldwide" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    security_group_id = aws_security_group.alb_security_group.id
    cidr_blocks = ["0.0.0.0/0"]
}

## availability zones must match the ones used for the targets in the ECS cluster
resource "aws_subnet" "subnets_for_alb" {
  for_each = var.alb_subnets_specs
  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.avail_zone

  tags = {
    Name = "${var.env_prefix}-cluster-subnet-${each.value.avail_zone}"
  }
}

resource "aws_alb" "stack_alb" {
    name               = "stack-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb_security_group.id]
    subnets            = [for subnet in aws_subnet.subnets_for_alb: subnet.id]

    tags = {
        Name = "${var.env_prefix}-stack-alb"
    }
}

resource "aws_alb_listener" "stack_alb_listener" {
    load_balancer_arn = aws_alb.stack_alb.arn
    port              = 80
    protocol          = "HTTP"

    # This is the default rule definition
    default_action {
        type          = "forward"
        target_group_arn = aws_alb_target_group.stack_alb_target_group.arn
    }

    tags = {
        Name = "${var.env_prefix}-stack-alb-listener"
    }
}

resource aws_alb_target_group "stack_alb_target_group" {
    name     = "stack-alb-target-group"
    port     = 8080
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    tags = {
        Name = "${var.env_prefix}-stack-alb-target-group"
    }
}
###



module "ecs_cluster_with_asg_capacity_provider" {
  source                          = "../.."
  asg_max_size                    = var.asg_max_size
  asg_min_size                    = var.asg_min_size
  ami_id                          = var.ami_id
  cluster_name                    = var.cluster_name
  container_definitions_file_path = var.container_definitions_file_path
  desired_count                   = var.desired_count
  env_prefix                      = var.env_prefix
  instance_type                   = var.instance_type
  load_balancers_list             = ## Provision a list that includes parameter for the ALB created
  service_name                    = var.service_name
  subnets_specs                   = var.subnets_specs
  task_definition_name            = var.task_definition_name
  vpc_id                          = aws_vpc.module_vpc.id
}
