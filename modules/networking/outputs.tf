output "subnets_ids_for_asg_instances" {
  value       = values(aws_subnet.cluster_subnets_for_asg_instances)[*].id
}
