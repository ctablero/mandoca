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

variable "lambda_function_filename" {
  description = "Path to the Lambda function zip file"
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

variable "vpc_id" {
  description = "The ID of the VPC where network resources will be deployed"
}