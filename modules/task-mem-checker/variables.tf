variable "cluster_arn" {
  description = "ARN of the ECS cluster"
  type        = string
}

variable "cluster_to_restart_name" {
  description = "Name of the ECS cluster to restart"
  type        = string
}

variable "lambda_function_filename" {
  description = "Path to the Lambda function zip file"
  type        = string
}

variable "service_arn" {
  description = "ARN of the ECS service"
  type        = string
}

variable "service_to_restart_name" {
  description = "Name of the ECS service to restart"
  type        = string
}
