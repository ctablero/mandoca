# References
# https://serverlessland.com/patterns/eventbridge-schedule-to-lambda-terraform-typescript

resource "aws_scheduler_schedule" "lambda_mem_checker" {
  name = "lambda-mem-checker"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression = "rate(10 minutes)"

  target {
    arn      = aws_lambda_function.mem_checker.arn
    role_arn = aws_iam_role.mem_checker_role.arn
  }
}
# Role for EventBridge Scheduler to invoke Lambda function
resource "aws_iam_role" "mem_checker_role" {
  name = "eventbridgeLambdaRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
            Service = "scheduler.amazonaws.com"
        }
        Action: "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "eventbridge_invoke_policy" {
  name = "eventbridge-invoke-policy"
  role = aws_iam_role.mem_checker_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid": "AllowEventbridgeToInvokeLambdaFunction",
        "Effect": "Allow",
        "Action": "lambda:InvokeFunction",
        "Resource": aws_lambda_function.mem_checker.arn
      }
    ]
  })

}

resource "aws_lambda_function" "mem_checker" {
  filename      = var.lambda_function_filename
  function_name = "mem_checker"
  role          = aws_iam_role.role_for_lambda.arn
  handler       = "mem_checker.lambda_handler"
  runtime       = "python3.12"
}

# Role for Lambda function to execute and interact with other AWS services
resource "aws_iam_role" "role_for_lambda" {
  name = "lambdaExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = ""
        Effect = "Allow"
        Principal = {
            Service = "lambda.amazonaws.com"
        }
        Action: "sts:AssumeRole"
      }
    ]
  })
}

# In here will be policies to permit Lambda to interact with other services like ECS, something similar to the way EC2 communicates with ECS in the identity module.
resource "aws_iam_role_policy" "lambda_execution_policy" {
  name = "lambdaExecutionPolicy"
  role = aws_iam_role.role_for_lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Sid": "AllowLambdaToRollingUpdateECSService",
        "Effect": "Allow",
        "Action": [
          "ecs:UpdateService",
          "ecs:DescribeServices"
        ],
        "Resource": var.cluster_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attachment_to_basic_execution_role_policy" {
  role = aws_iam_role.role_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}