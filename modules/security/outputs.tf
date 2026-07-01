output "security_group_id_for_asg_instances" {
  value = aws_security_group.asg_instances_sg.id
}
