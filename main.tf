module "cluster" {
  source                          = "./modules/cluster"
  cluster_name                    = var.cluster_name
  desired_count                   = var.desired_count
  service_name                    = var.service_name
  task_definition_name            = var.task_definition_name
  container_definitions_file_path = var.container_definitions_file_path
}

#TODO security-groups module

module "asg-provider" {
  source = "./modules/asg-provider"
  ami_id = var.ami_id
  instance_type = var.instance_type
  #security_group_ids = module.security-groups.security_group_asg_provider_ids
}
