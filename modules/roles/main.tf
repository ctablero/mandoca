# Resources for permitting instances to communicate with ECS and other AWS services

resource "aws_iam_role" "ecs_instance_role" {
  name = "ecsInstanceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy_attachment" {
    role       = aws_iam_role.ecs_instance_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
    name = "ecs-instance-profile"
    role = aws_iam_role.ecs_instance_role.name
}

# Resources for permitting ECS tasks to communicate with other AWS services
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role_policy_attachment" {
    role       = aws_iam_role.ecs_instance_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Optional: If you want to allow ECS tasks to access other AWS services, you can create extra roles 
# and attach additional policies. Then add that role to the to the ecs_task_role property of the task_definition resource. 
# For example, if your tasks need to access S3, you can attach the AmazonS3ReadOnlyAccess policy
