resource "aws_security_group" "asg_instances_sg" {
  name        = "asg-instances-sg"
  description = "Security group for ASG instances"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.env_prefix}-asg-instances-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "asg_instances_sg_allow_http_from_alb" {
  count                        = var.elb_enabled == true ? 1 : 0
  security_group_id            = aws_security_group.asg_instances_sg.id
  referenced_security_group_id = aws_security_group.elb_security_group[0].id
  
  from_port                    =  80
  to_port                      =  80
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "asg_instances_sg_allow_all_outbounds" {
  security_group_id = aws_security_group.asg_instances_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  tags = {
    Name = "${var.env_prefix}-asg-instances-sg-allow-all-outbounds"
  }
}

resource "aws_security_group" "elb_security_group" {
  count  = var.elb_enabled == true ? 1 : 0  

  name   = "${var.env_prefix}-elb-security-group"
  vpc_id = var.vpc_id

  tags = {
      Name = "${var.env_prefix}-elb-security-group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "elb_security_group_rule_http_inbounds_to_worldwide" {
  count              = var.elb_enabled == true ? 1 : 0

  security_group_id  = aws_security_group.elb_security_group[0].id
  
  cidr_ipv4          = "0.0.0.0/0"
  from_port          =  80
  to_port            =  80
  ip_protocol        = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "elb_security_group_rule_http_outbounds_to_asg_instances" {
  count                        = var.elb_enabled == true ? 1 : 0

  security_group_id            = aws_security_group.elb_security_group[0].id
  referenced_security_group_id = aws_security_group.asg_instances_sg.id
  
  from_port                    =  80
  to_port                      =  80
  ip_protocol                  = "tcp"
}