module "cluster" {
  source                          = "./modules/cluster"
  auto_scaling_group_arn          = module.asg-provider.auto_scaling_group_arn
  cluster_name                    = var.cluster_name
  desired_count                   = var.desired_count
  service_name                    = var.service_name
  task_definition_name            = var.task_definition_name
  container_definitions_file_path = var.container_definitions_file_path
}

module "networking" {
  source        = "./modules/networking"
  env_prefix    = var.env_prefix
  vpc_id        = var.vpc_id
  subnets_specs = var.subnets_specs
}

module "asg-provider" {
  source        = "./modules/asg-provider"
  ami_id        = var.ami_id
  instance_type = var.instance_type
  subnets_ids   = module.networking.subnets_ids_for_asg_instances
}
