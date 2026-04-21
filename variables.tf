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

variable "service_name" {
  type        = string
  description = "Name of the service"
}

variable "task_definition_name" {
  type        = string
  description = "Name of the task definition"
}
