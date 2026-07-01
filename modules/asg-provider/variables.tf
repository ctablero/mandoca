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

variable "instance_type" {
  description = "The instance type to use for the instances in the Auto Scaling group."
  type        = string
}

variable "iam_instance_profile_name" {
  description = "The name of the IAM instance profile to associate with the instances in the Auto Scaling group."
  type        = string
}

variable "security_group_id_for_asg_instances" {
  description = "The ID of the security group to associate with the instances in the Auto Scaling group."
  type        = string
}

variable "subnets_ids" {
  description = "A list of subnet IDs where the Auto Scaling group instances will be launched."
  type        = list(string)
}