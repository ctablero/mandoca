resource "aws_alb" "stack_alb" {
  name               = "stack-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups_ids
  subnets            = var.subnets_ids

  tags = {
    Name = "${var.env_prefix}-stack-alb"
  }
}

resource "aws_alb_listener" "stack_alb_listener" {
  load_balancer_arn = aws_alb.stack_alb.arn
  port              = 80
  protocol          = "HTTP"

  # This is the default rule definition
  default_action {
    type          = "forward"
    target_group_arn = aws_alb_target_group.stack_alb_target_group.arn
  }

  tags = {
    Name = "${var.env_prefix}-stack-alb-listener"
  }
}

resource aws_alb_target_group "stack_alb_target_group" {
  name        = "stack-alb-target-group"
  port        = 80 # This port will be automatically overwritten once the TG is associated with the ECS
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.module_vpc.id

  tags = {
    Name = "${var.env_prefix}-stack-alb-target-group"
  }
}