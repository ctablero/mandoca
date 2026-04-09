module "cluster" {
  source                          = "./modules/cluster"
  cluster_name                    = var.cluster_name
  desired_count                   = var.desired_count
  service_name                    = var.service_name
  task_definition_name            = var.task_definition_name
  container_definitions_file_path = var.container_definitions_file_path
}
