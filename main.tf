module "identity" {
  source = "./modules/identity"
}

module "security" {
  source      = "./modules/security"
  elb_enabled = var.elb_enabled
  vpc_id      = var.vpc_id
  env_prefix  = var.env_prefix
}

module "elb" {
  count = var.elb_enabled == true ? 1 : 0
  source = "./modules/elb"
  env_prefix          = var.env_prefix
  security_groups_ids = module.security.security_groups_ids_for_elb
  subnets_ids         = module.networking.subnets_ids
  vpc_id              = var.vpc_id
}

module "secrets" {
  source = "./modules/secrets"
}

module "cluster" {
  source                          = "./modules/cluster"
  auto_scaling_group_arn          = module.asg-provider.auto_scaling_group_arn
  cluster_name                    = var.cluster_name
  desired_count                   = var.desired_count
  load_balancers_specs_list       = var.elb_enabled == true ? [
    {
      target_group_arn = try(module.elb[0].stack_elb_target_group_arn, "")
      container_name   = "sample-ec2-provider-app" # Replace with your container name
      container_port   = 80 # Replace with your container port
    }
  ]: []
  service_name                    = var.service_name
  task_definition_name            = var.task_definition_name
  ecs_task_execution_role_arn     = module.identity.ecs_task_execution_role_arn
  container_definitions_file_path = var.container_definitions_file_path
  redis_endpoint_arn              = module.secrets.redis_endpoint_arn
}

module "networking" {
  source        = "./modules/networking"
  env_prefix    = var.env_prefix
  vpc_id        = var.vpc_id
  subnets_specs = var.subnets_specs
}

module "asg-provider" {
  asg_max_size                         = var.asg_max_size
  asg_min_size                         = var.asg_min_size
  iam_instance_profile_name            = module.identity.iam_instance_profile_name
  security_group_ids_for_asg_instances = module.security.security_group_ids_for_asg_instances
  source                               = "./modules/asg-provider"
  ami_id                               = var.ami_id
  instance_type                        = var.instance_type
  subnets_ids                          = module.networking.subnets_ids
}
