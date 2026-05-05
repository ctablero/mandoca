module "cluster" {
  source                          = "./modules/cluster"
  auto_scaling_group_arn          = module.asg-provider.auto_scaling_group_arn
  cluster_name                    = var.cluster_name
  desired_count                   = var.desired_count
  service_name                    = var.service_name
  task_definition_name            = var.task_definition_name
  container_definitions_file_path = var.container_definitions_file_path
}

# TODO Create networking module. Prepare subnets to provide to the asg-provider module.

module "asg-provider" {
  source = "./modules/asg-provider"
  ami_id = var.ami_id
  instance_type = var.instance_type
}
