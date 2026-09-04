output "redis_endpoint_arn" {
  value = data.aws_secretsmanager_secret.redis_endpoint.arn
}