output "subnets_ids" {
  value       = values(aws_subnet.cluster_subnets)[*].id
}
