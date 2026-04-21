resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

#Capacity providers
resource "aws_ecs_cluster_capacity_providers" "capacity_providers" {
  cluster_name       = aws_ecs_cluster.cluster.name
  capacity_providers = [aws_ecs_cluster_capacity_provider.asg_provider.name]
}

resource "aws_ecs_cluster_capacity_provider" "asg_provider" {
  name = "asg-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.auto_scaling_group_arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status                    = "ENABLED"
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 2
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = var.desired_count

  deployment_configuration {
    strategy = "BLUE_GREEN"
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family = var.task_definition_name

  container_definitions = file(var.container_definitions_file_path)
}