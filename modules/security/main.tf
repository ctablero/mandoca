resource "aws_security_group" "asg_instances_sg" {
  name        = "asg-instances-sg"
  description = "Security group for ASG instances"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.env_prefix}"
  }
}

resource "aws_vpc_security_group_egress_rule" "asg_instances_sg_allow_all_outbounds" {
  security_group_id = aws_security_group.asg_instances_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
