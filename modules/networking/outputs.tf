output "internal_subnets_ids" {
  value       = values(aws_subnet.internal_subnets)[*].id
}

output "external_subnets_ids" {
  value       = values(aws_subnet.external_subnets)[*].id
}
