variable "cluster_arn" {
  description = "ARN of the ECS cluster"
  type        = string
}

variable "lambda_function_filename" {
  description = "Path to the Lambda function zip file"
  type        = string
}