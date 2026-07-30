variable "env_prefix" {
  description = "Environment prefix for naming resources"
  type        = string
}

variable "security_groups_ids" {
  description = "The IDs of the security groups to associate with the ELB."
  type        = string
}

variable "subnets_ids" {
  description = "A list of subnet IDs where the Auto Scaling group instances will be launched."
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC where the resources will be created."
  type        = string
}