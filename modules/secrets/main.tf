# Retrieve secrets using pairs of secret and secret version data
data "aws_secretsmanager_secret" "redis_endpoint" {
  name = "redis-endpoint"
}
