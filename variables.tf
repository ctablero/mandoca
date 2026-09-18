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

variable "ami_id"  {
  description = "The ID of the AMI to use for the instances in the Auto Scaling group."
  type        = string
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

variable "elb_enabled" {
  description = "Flag to determine whether to create resources related to ELB."
  type        = bool
  default     = false
}

variable "env_prefix" {
  description = "Environment prefix for naming resources"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "service_name" {
  type        = string
  description = "Name of the service"
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

variable "task_definition_name" {
  type        = string
  description = "Name of the task definition"
}

variable "vpc_id" {
  description = "The ID of the VPC where network resources will be deployed"
}