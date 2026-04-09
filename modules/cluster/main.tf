resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

resource "aws_ecs_service" "service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_task_definition.task_definition.arn
  desired_count   = var.desired_count

  deployment_configuration {
    strategy = "BLUE_GREEN"
  }
}

resource "aws_task_definition" "task_definition" {
  family = var.task_definition_name

  container_definitions = file(var.container_definitions_file_path)
}