output "security_group_ids_for_asg_instances" {
  value = [aws_security_group.asg_instances_sg.id]
}

output "security_groups_ids_for_elb" {
  value = [length(aws_security_group.elb_security_group) > 0 ? aws_security_group.elb_security_group[0].id : null]
}
