variable "enable_nat_gateway" {
  description = "Boolean flag to determine whether to create a NAT Gateway to give private subnets access to the internet"
  type        = bool
  default     = false
}

variable "env_prefix" {
  description = "Environment prefix for naming resources"
  type        = string
}

variable "subnets_specs" {
  description = "A map of subnet specifications for ASG instances. Each key is a unique identifier for the subnet, and the value is an object containing 'cidr_block' and 'avail_zone'."
  type        = map(object({
    cidr_block = string
    avail_zone = string
  }))
}

variable "vpc_id" {
  description = "The ID of the VPC where network resources will be deployed"
}