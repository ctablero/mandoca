module "identity" {
  source = "./modules/identity"
}

module "security" {
  source     = "./modules/security"
  vpc_id     = var.vpc_id
  env_prefix = var.env_prefix
}

module "cluster" {
  source                          = "./modules/cluster"
  auto_scaling_group_arn          = module.asg-provider.auto_scaling_group_arn
  cluster_name                    = var.cluster_name
  desired_count                   = var.desired_count
  service_name                    = var.service_name
  task_definition_name            = var.task_definition_name
  ecs_task_execution_role_arn     = module.identity.ecs_task_execution_role_arn
  container_definitions_file_path = var.container_definitions_file_path
}

module "networking" {
  source        = "./modules/networking"
  env_prefix    = var.env_prefix
  vpc_id        = var.vpc_id
  subnets_specs = var.subnets_specs
}

module "asg-provider" {
  asg_max_size                        = var.asg_max_size
  asg_min_size                        = var.asg_min_size
  iam_instance_profile_name           = module.identity.iam_instance_profile_name
  security_group_id_for_asg_instances = module.security.security_group_id_for_asg_instances
  source                              = "./modules/asg-provider"
  ami_id                              = var.ami_id
  instance_type                       = var.instance_type
  subnets_ids                         = module.networking.subnets_ids_for_asg_instances
}
