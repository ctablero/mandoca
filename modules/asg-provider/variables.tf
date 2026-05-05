variable "ami_id"  {
  description = "The ID of the AMI to use for the instances in the Auto Scaling group."
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the instances in the Auto Scaling group."
  type        = string
}
