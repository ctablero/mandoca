variable auto_scaling_group_arn {
  type        = string
  description = "ARN of the Auto Scaling Group to be used as a capacity provider"
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

variable "load_balancers_specs_list" {
  type = list(object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  }))
  description = "List of load balancers to be associated with the ECS service"
  default     = []
}

variable "service_name" {
  type        = string
  description = "Name of the service"
}

variable "task_definition_name" {
  type        = string
  description = "Name of the task definition"
}

variable "ecs_task_execution_role_arn" {
  type        = string
  description = "ARN of the ECS task execution role"
}