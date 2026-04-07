provider "aws" {
    region = "us-east-1"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

module "ecs_cluster_with_self_managed_ec2" {
  source = "../.."
  cluster_name = var.cluster_name
}
