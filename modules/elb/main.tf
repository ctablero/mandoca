resource "aws_lb" "stack_elb" {
  name               = "stack-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups_ids
  subnets            = var.subnets_ids

  tags = {
    Name = "${var.env_prefix}-stack-elb"
  }
}

resource "aws_lb_listener" "stack_elb_listener" {
  load_balancer_arn = aws_lb.stack_elb.arn
  port              = 80
  protocol          = "HTTP"

  # This is the default rule definition
  default_action {
    type          = "forward"
    target_group_arn = aws_lb_target_group.stack_elb_target_group.arn
  }

  tags = {
    Name = "${var.env_prefix}-stack-elb-listener"
  }
}

resource aws_lb_target_group "stack_elb_target_group" {
  name        = "stack-elb-target-group"
  port        = 80 # This port will be automatically overwritten once the TG is associated with the ECS
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.env_prefix}-stack-elb-target-group"
  }
}