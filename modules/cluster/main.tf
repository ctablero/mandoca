resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

#Capacity providers
resource "aws_ecs_cluster_capacity_providers" "capacity_providers" {
  cluster_name       = aws_ecs_cluster.cluster.name
  capacity_providers = [aws_ecs_capacity_provider.asg_provider.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.asg_provider.name
    base              = 1
    weight            = 100
  }
}

resource "aws_ecs_capacity_provider" "asg_provider" {
  name = "asg-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.auto_scaling_group_arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      status                    = "ENABLED"
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 1
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = var.desired_count

  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  force_new_deployment = true

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.asg_provider.name
    weight            = 100
  }
  
  # Permits zero or more load balancers associated with the service
  dynamic "load_balancer" {
    for_each = var.load_balancers_list
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family = var.task_definition_name
  network_mode = "bridge"
  execution_role_arn = var.ecs_task_execution_role_arn

  container_definitions = file(var.container_definitions_file_path)

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}