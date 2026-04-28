variable "ami_id"  {
  description = "The ID of the AMI to use for the instances in the Auto Scaling group."
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the instances in the Auto Scaling group."
  type        = string
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with the instances in the Auto Scaling group."
  type        = list(string)
}