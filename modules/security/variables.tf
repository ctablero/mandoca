variable "elb_enabled" {
  description = "Flag to determine whether to create resources related to ELB."
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created."
  type        = string
}

variable "env_prefix" {
  description = "Environment prefix ."
  type        = string
}
