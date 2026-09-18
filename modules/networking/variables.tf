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

variable "vpc_id" {
  description = "The ID of the VPC where network resources will be deployed"
}